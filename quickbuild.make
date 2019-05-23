# This is a generated file
#
#  You can get the uncompressed and better commented original version
#  of this file from:
#
#      https://raw.githubusercontent.com/lanceman2/quickbuild/0.1/quickbuild.make
#

SHELL = /bin/bash
.ONESHELL:
QUICKBUILD_VERSION := 0.1
ifdef top_srcdir
ifdef BUILD_PREFIX
$(error You cannot make a build tree with a directory that is not a source tree)
endif
ifneq ($(strip $(wildcard $(top_srcdir)/config.make)),)
$(error You have already configured this package in $(top_srcdir)\
 so now you cannot configure and build it here too)
endif
endif # ifdef top_srcdir
ifdef BUILD_PREFIX
ifneq ($(strip $(wildcard $(BUILD_PREFIX)/GNUmakefile)),)
$(error BUILD_PREFIX makefile $(BUILD_PREFIX)/GNUmakefile exists already)
endif
this_file := $(notdir $(lastword $(MAKEFILE_LIST)))
top_srcdir = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
abs_top_srcdir = $(abspath $(top_srcdir))
build_prefix:
	set -e
	mkdir -p $(BUILD_PREFIX)
	echo -e "# This is a generated file\n" > $(BUILD_PREFIX)/$(this_file)
	echo -e "ifdef top_srcdir\n\$$(error top_srcdir should not be defined)\nendif\n" >> $(BUILD_PREFIX)/$(this_file)
	echo -e "\ntop_srcdir := $(abs_top_srcdir)\n\n" >> $(BUILD_PREFIX)/$(this_file)
	cat $(abs_top_srcdir)/$(this_file) >> $(BUILD_PREFIX)/$(this_file)
	function cp_make()\
 {\
 while [ -n "$$1" ] ; do \
 if [ -f $(abs_top_srcdir)/$$1 ] ; then\
 mkdir -p $$(dirname $(BUILD_PREFIX)/$$1) ;\
 cp $(abs_top_srcdir)/$$1 $(BUILD_PREFIX)/$$1 ;\
 cp_make $$1/*/GNUmakefile ;\
 fi ; shift ; done ;\
}
	cp_make */GNUmakefile
	cp $(abs_top_srcdir)/GNUmakefile $(BUILD_PREFIX)
	set -x
	echo -e "\n  made build directory: $(BUILD_PREFIX)\n"
else # ifdef BUILD_PREFIX
.DEFAULT_GOAL := build
rec_targets := build install download clean cleaner distclean debug
.PHONEY: $(rec_targets)
$(rec_targets):
ifndef subdirs
subdirs := $(sort $(patsubst %/GNUmakefile,%,$(wildcard */GNUmakefile)))
endif
ifdef SUBDIRS # user interface to reorder or just change the sub-directories
subdirs := $(strip $(SUBDIRS))
endif
ifeq ($(subdirs),.)
subdirs :=
endif
ifneq ($(subdirs),)
rec :=
ifeq ($(strip $(MAKECMDGOALS)),)
    rec := build
else
  define CheckForRecursive
    rec += $$(patsubst oZZ%ZXx,%,$$(findstring oZZ$(1)ZXx, $$(addsuffix ZXx,$$(addprefix oZZ,$(MAKECMDGOALS)))))
  endef
  $(foreach targ,$(rec_targets),$(eval $(call CheckForRecursive,$(targ))))
  undefine CheckForRecursive
endif
rec_target := $(strip $(firstword $(rec)))
undefine rec
endif # ifneq ($(subdirs),)
ifneq ($(rec_target),)
$(rec_target): rec_$(rec_target)
rec_$(rec_target):
	set -e
	for d in $(subdirs) ; do\
          $(MAKE) -C $$d $(patsubst rec_%,%,$(@)); done
	$(MAKE) subdirs= $(patsubst rec_%,%,$(@))
else #ifneq ($(rec_target),)
top_builddir := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
ifeq ($(top_builddir),.)
configmakefile := config.make
else
configmakefile := $(top_builddir)/config.make
endif
ifndef top_srcdir
top_srcdir = $(top_builddir)
srcdir = .
else # ifndef top_srcdir
ifeq ($(top_builddir),.)
srcdir = $(top_srcdir)
else
srcdir = $(patsubst $(abspath $(top_builddir))/%, $(abspath $(top_srcdir))/%,\
 $(abspath $(dir $(firstword $(MAKEFILE_LIST)))))
endif
endif # ifndef top_srcdir
ifneq ($(strip $(srcdir)),.)
VPATH := .:$(srcdir)
cppflags := -I. -I$(srcdir)
endif
concat_vars := CPPFLAGS LDFLAGS CFLAGS ADDLIBS CXXFLAGS
define Var_concat
  ifdef $(1)
    concat_$(1) := $$(strip $$(concat_$(1)) $$($(1)))
  endif
endef
define Undefine
  undefine $(1)
endef
$(foreach var,$(concat_vars),$(eval $(call Var_concat,$(var))))
$(foreach var,$(concat_vars),$(eval $(call Undefine,$(var))))
ifeq ($(findstring config.make,$(MAKEFILE_LIST)),)
config_inc := yes
targ := $(strip $(MAKECMDGOALS))
ifeq ($(targ),clean)
  config_inc := no
endif
ifeq ($(targ),cleaner)
  config_inc := no
endif
ifeq ($(targ),distclean)
  config_inc := no
endif
ifeq ($(targ),config.make)
  config_inc := no
endif
ifeq ($(targ),config)
  config_inc := no
endif
ifeq ($(config_inc),yes)
  -include $(configmakefile)
endif
undefine config_inc
ifneq ($(findstring config.make,$(MAKEFILE_LIST)),)
  $(foreach var,$(concat_vars),$(eval $(call Var_concat,$(var))))
  $(foreach var,$(concat_vars),$(eval $(call Undefine,$(var))))
endif
endif # ifeq ($(findstring config.make,$(MAKEFILE_LIST)),)
ifeq ($(findstring package.make,$(MAKEFILE_LIST)),)
  -include $(top_srcdir)/package.make
  $(foreach var,$(concat_vars),$(eval $(call Var_concat,$(var))))
  $(foreach var,$(concat_vars),$(eval $(call Undefine,$(var))))
endif
CSS_COMPRESS ?= cat
JS_COMPRESS ?= cat
ifdef TAR_NAME
PREFIX ?= $(HOME)/installed/$(TAR_NAME)
else
PREFIX ?= $(HOME)/installed
endif
.SUFFIXES: # Delete the default suffixes
.SUFFIXES: .js .css .html .js .css .jsp .cs .dl .bl .c .cpp .h .hpp .d .o .lo .so .x3d
seds := $(sort\
 $(IN_VARS)\
)
ifeq ($(seds),)
DUMMY_Z := dummy_z
seds := DUMMY_Z
endif
sed_commands :=
define AddInReplace
  sed_commands := $$(sed_commands) -e 's!@$(1)@!$$(strip $$($(1)))!g'
endef
$(foreach cmd,$(seds),$(eval $(call AddInReplace,$(cmd))))
undefine seds
define Dependify
  $(1): $(1).$(2)
endef
define Set755Mode
  $(1)_MODE := 0755
endef
dl_scripts := $(sort\
 $(patsubst $(srcdir)/%.dl,%,$(wildcard $(srcdir)/*.dl))\
 $(patsubst $(srcdir)/%.dl.in,%,$(wildcard $(srcdir)/*.dl.in))\
)
$(foreach targ,$(dl_scripts),$(eval $(call Dependify,$(targ),dl)))
dl_in_scripts :=\
 $(patsubst $(srcdir)/%.dl.in,%.dl,$(wildcard $(srcdir)/*.dl.in))
$(foreach targ,$(dl_in_scripts),$(eval $(call Set755Mode,$(targ))))
undefine dl_in_scripts
undefine Set755Mode
in_files := $(sort\
 $(patsubst $(srcdir)/%.in,%,$(wildcard $(srcdir)/*.in))\
)
$(foreach targ,$(in_files),$(eval $(call Dependify,$(targ),in)))
bl_in_scripts := $(sort\
 $(patsubst $(srcdir)/%.bl.in,%,$(wildcard $(srcdir)/*.bl.in))\
)
$(foreach targ,$(bl_in_scripts),$(eval $(call Dependify,$(targ),bl)))
bl_scripts := $(sort $(filter-out $(bl_in_scripts),\
 $(patsubst $(srcdir)/%.bl,%,$(wildcard $(srcdir)/*.bl))\
))
$(foreach targ,$(bl_scripts),$(eval $(call Dependify,$(targ),bl)))
undefine Dependify
downloaded := $(sort\
 $(dl_scripts)\
 $(DOWNLOADED)\
)
bins := $(filter-out %.so, $(patsubst %_SOURCES,%,$(filter %_SOURCES, $(.VARIABLES))))
libs := $(filter-out %_SOURCES, $(patsubst %.so_SOURCES,%.so,$(filter %_SOURCES, $(.VARIABLES))))
dependfiles :=
id :=
objects :=
c_compile := $(CC)
cpp_compile := $(CXX)
define Mkdepend
 id := $(words $(counter))
 name := $$(patsubst %.so,%_so,qb_build/$$(notdir $(2)-$$(id)-$(1)))
 counter := $$(counter) x
 $$(name).d_target := $$(name).$(4)
 $$(name).$(4)_compile := $$($(3)_compile)
 $$(name).d_compile := $$($(3)_compile)
 $$(name).d $$(name).$(4): $(2).$(3)
 dependfiles := $(dependfiles) $$(name).d
 $(1)_objects := $$(strip $$($(1)_objects) $$(name).$(4))
 common_cflags := $(cppflags) $$(concat_CPPFLAGS) $$($$(name).$(4)_CPPFLAGS) $$($(1)_CPPFLAGS)
 ifeq ($(3),c)
   $$(name).$(4)_cflags := $$(strip $$(concat_CFLAGS) $$(common_cflags) $$($(1)_CFLAGS) $$($$(name).$(4)_CFLAGS))
 else
   $$(name).$(4)_cflags := $$(strip $$(concat_CXXFLAGS) $$(common_cflags) $$($(1)_CXXFLAGS) $$($$(name).$(4)_CXXFLAGS))
 endif
 $$(name).d_cflags := $$($$(name).$(4)_cflags)
endef
define Mkcpprules
  counter := x
  cpp_srcfiles :=  $$(patsubst %.cpp,%,$$(filter %.cpp,$$($(1)_SOURCES)))
  ifneq ($$(strip $$(cpp_srcfiles)),)
    $(1)_compile := $(CXX)
    $(1)_cflags := $$(strip $(3) $$(concat_CXXFLAGS) $$($(1)_CXXFLAGS))
  else
    $(1)_compile := $(CC)
    $(1)_cflags := $$(strip $(3) $$(concat_CFLAGS) $$($(1)_CFLAGS))
  endif
  c_srcfiles :=  $$(patsubst %.c,%,$$(filter %.c,$$($(1)_SOURCES)))
  $$(foreach src,$$(cpp_srcfiles),$$(eval $$(call Mkdepend,$(1),$$(src),cpp,$(2))))
  $$(foreach src,$$(c_srcfiles),$$(eval $$(call Mkdepend,$(1),$$(src),c,$(2))))
  $(1): $$($(1)_objects)
  ldadd :=
  $(1)_ADDLIBS := $$($(1)_ADDLIBS) $$(concat_ADDLIBS)
  ifneq ($$(strip $$($(1)_ADDLIBS)),)
    dirr := $$(patsubst %/,%,$(CURDIR)/$$(dir $$($(1)_ADDLIBS)))
    name := $$(patsubst lib%.so,%,$$(notdir $$($(1)_ADDLIBS)))
    ldadd := -l$$(name) -L$$(dirr) -Wl,-rpath,$$(dirr)
    undefine dirr
    undefine name
  endif
  $(1)_ldflags := $$(strip $$(ldadd) $$(concat_LDFLAGS) $$($(1)_LDFLAGS))
  objects := $$(objects) $$($(1)_objects)
  ifneq ($$(strip $$($(1)_INSTALL_RPATH)),)
    ifneq ($$(strip $$(POST_INSTALL_COMMAND)),)
      POST_INSTALL_COMMAND := $$(POST_INSTALL_COMMAND) &&
    endif
    POST_INSTALL_COMMAND :=\
 $$(POST_INSTALL_COMMAND) patchelf --set-rpath $$($(1)_INSTALL_RPATH)\
 $(INSTALL_DIR)/$(1)
  endif
endef
$(foreach prog,$(bins),$(eval $(call Mkcpprules,$(prog),o,)))
$(foreach lib,$(libs),$(eval $(call Mkcpprules,$(lib),lo,-shared)))
undefine ldadd
undefine id
undefine counter
undefine srcfiles
undefine Mkdepend
undefine Mkcpprules
undefine cpp_srcfiles
undefine c_srcfiles
undefine c_compile
undefine cpp_compile
common_built := $(sort\
\
 $(patsubst $(srcdir)/%.jsp,%.js,$(wildcard $(srcdir)/*.jsp))\
 $(patsubst $(srcdir)/%.cs,%.css,$(wildcard $(srcdir)/*.cs))\
\
 $(patsubst $(srcdir)/%.jsp.in,%.js,$(wildcard $(srcdir)/*.jsp.in))\
 $(patsubst $(srcdir)/%.cs.in,%.css,$(wildcard $(srcdir)/*.cs.in))\
\
 $(patsubst $(srcdir)/%.jsp.bl.in,%.js,$(wildcard $(srcdir)/*.jsp.bl.in))\
 $(patsubst $(srcdir)/%.cs.bl.in,%.css,$(wildcard $(srcdir)/*.cs.bl.in))\
\
 $(patsubst $(srcdir)/%.js.bl,%.js,$(wildcard $(srcdir)/*.js.bl))\
 $(patsubst $(srcdir)/%.css.bl,%.css,$(wildcard $(srcdir)/*.css.bl))\
\
 $(patsubst $(srcdir)/%.js.in,%.js,$(wildcard $(srcdir)/*.js.in))\
 $(patsubst $(srcdir)/%.css.in,%.css,$(wildcard $(srcdir)/*.css.in))\
\
 $(patsubst $(srcdir)/%.js.bl.in,%.js,$(wildcard $(srcdir)/*.js.bl.in))\
 $(patsubst $(srcdir)/%.css.bl.in,%.css,$(wildcard $(srcdir)/*.css.bl.in))\
\
 $(patsubst $(srcdir)/%.jsp.bl,%.js,$(wildcard $(srcdir)/*.jsp.bl))\
 $(patsubst $(srcdir)/%.cs.bl,%.css,$(wildcard $(srcdir)/*.cs.bl))\
\
 $(patsubst $(srcdir)/%.js.dl,%.js,$(wildcard $(srcdir)/*.js.dl))\
 $(patsubst $(srcdir)/%.jsp.dl,%.js,$(wildcard $(srcdir)/*.jsp.dl))\
 $(patsubst $(srcdir)/%.css.dl,%.css,$(wildcard $(srcdir)/*.css.dl))\
 $(patsubst $(srcdir)/%.cs.dl,%.css,$(wildcard $(srcdir)/*.cs.dl))\
\
 $(patsubst $(srcdir)/%.html.in,%.html,$(wildcard $(srcdir)/*.html.in))\
 $(patsubst $(srcdir)/%.html.bl,%.html,$(wildcard $(srcdir)/*.html.bl))\
 $(patsubst $(srcdir)/%.html.bl.in,%.html,$(wildcard $(srcdir)/*.html.bl.in))\
\
 $(patsubst $(srcdir)/%.x3d.bl,%.x3d,$(wildcard $(srcdir)/*.x3d.bl))\
 $(patsubst $(srcdir)/%.x3d.in,%.x3d,$(wildcard $(srcdir)/*.x3d.in))\
 $(patsubst $(srcdir)/%.x3d.bl.in,%.x3d,$(wildcard $(srcdir)/*.x3d.bl.in))\
 $(patsubst $(srcdir)/%.x3d.dl,%.x3d,$(wildcard $(srcdir)/*.x3d.dl))\
\
 $(bins)\
 $(libs)\
 $(BUILD)\
 $(BUILD_NO_INSTALL)\
 $(BUILD_NO_CLEAN)\
)
installed := $(sort $(filter-out $(BUILD_NO_INSTALL) $(BUILD_NO_CLEAN),\
 $(common_built)\
 $(patsubst $(srcdir)/%,%,$(wildcard\
 $(srcdir)/*.js\
 $(srcdir)/*.css\
 $(srcdir)/*.html\
 $(srcdir)/*.gif\
 $(srcdir)/*.jpg\
 $(srcdir)/*.png\
 $(srcdir)/*.x3d))\
 $(INSTALLED)\
))
built := $(sort $(filter-out $(downloaded),\
 $(common_built)\
 $(bl_scripts)\
 $(bl_in_scripts)\
 $(in_files)\
))
ifneq ($(in_files),)
built_dep := $(sort $(dependfiles) $(filter-out $(in_files), $(built)))
ifneq ($(built_dep),)
$(built_dep): $(in_files)
endif
undefine built_dep
endif
installed_src := $(sort $(filter-out $(built), $(installed)))
installed_built := $(sort $(filter-out $(installed_src), $(installed)))
installed_src := $(sort $(patsubst %,$(srcdir)/%,$(patsubst\
 $(srcdir)/%,%,$(installed_src) $(INSTALLED_SRC))))
installed := $(sort $(installed_built) $(installed_src))
cleanfiles := $(sort $(built) $(CLEANFILES))
cleanerfiles := $(sort $(CLEANERFILES) $(wildcard *.pyc))
ifeq ($(strip $(top_builddir)),.)
    cleanerfiles := $(cleanerfiles) $(configmakefile)
endif
ifneq ($(sort $(BUILD_NO_CLEAN)),)
cleanfiles := $(sort $(filter-out $(BUILD_NO_CLEAN), $(cleanfiles)))
cleanerfiles := $(sort $(filter-out $(BUILD_NO_CLEAN), $(cleanerfiles)))
endif
cleandirs := $(CLEANDIRS)
ifneq ($(strip $(objects)),)
  cleandirs := $(sort $(cleandirs) qb_build)
$(dependfiles) $(objects): qb_build/depend.touch
qb_build/depend.touch:
	mkdir qb_build
	touch $@
qb_build/%.o:
	$($@_compile) $($@_cflags) -c $< -o $@
qb_build/%.lo:
	$($@_compile) $($@_cflags) -fPIC -c $< -o $@
qb_build/%.d:
	$($@_compile) $($@_cflags) -MM $< -MF $@ -MT $($@_target)
$(bins) $(libs):
	$($@_compile) $($@_cflags) $($@_objects) -o $@ $($@_ldflags)
nodepend := $(strip\
 $(findstring clean, $(MAKECMDGOALS))\
)
ifeq ($(nodepend),)
ifneq ($(strip $(MAKECMDGOALS)),download)
-include $(dependfiles)
endif
endif
undefine nodepend
endif # ifneq ($(strip $(objects)),)
build: $(downloaded) $(built)
$(built): | $(downloaded)
debug:
	@echo "BUILD=$(BUILD)"
	@echo "objects=$(objects)"
	@echo "cleanerfiles=$(cleanerfiles)"
	@echo "cleanfiles=$(cleanfiles)"
	@echo "INSTALL_DIR=$(INSTALL_DIR)"
	@echo "built=$(built)"
	@echo "downloaded=$(downloaded)"
	@echo "installed=$(installed)"
	@echo "installed_built=$(installed_built)"
	@echo "installed_src=$(installed_src)"
	@echo "dependfiles=$(dependfiles)"
	@echo "srcdir=$(srcdir)"
	@echo "top_srcdir=$(top_srcdir)"
	@echo "top_builddir=$(top_builddir)"
	@echo "IN_VARS=$(IN_VARS)"
	@echo "sed_commands= $(sed_commands)"
help:
	@echo -e "  $(MAKE) [TARGET]\n"
	@echo -e "  Common TRAGETs are:"
	@echo -e '$(foreach \
	    var,$(rec_targets),\n   $(var))' 
$(dl_scripts):
	$(srcdir)/$@.dl || exit 1
$(bl_scripts):
	$(srcdir)/$@.bl || exit 1
$(bl_in_scripts):
	./$@.bl || exit 1
$(in_files):
	rm -f $@
	if head -1 $< | grep -E '^#!' ; then\
	  sed -n '1,1p' $< | sed $(sed_commands) > $@ &&\
          if [ -n "$($@_GEN_COMMENT)" ] ; then\
            echo -e "$($@_GEN_COMMENT)"  >> $@ ;\
          else\
	    echo -e "# This is a generated file\n" >> $@ ;\
	  fi ;\
	  sed '1,1d' $< | sed $(sed_commands) >> $@ ;\
	elif [[ "$@" =~ \.jsp$$|\.js$$|\.cs$$|\.css$$|\.h$$|\.c$$|\.hpp$$|\.cpp$$ ]] ; then\
	  echo -e "/* This is a generated file */\n" > $@ &&\
	  sed $< $(sed_commands) >> $@ ;\
	else\
	  if [ -n "$($@_GEN_COMMENT)" ] ; then\
            echo -e "$($@_GEN_COMMENT)"  > $@ ; fi;\
	  sed $< $(sed_commands) >> $@ ; fi
	if [[ $@ == *.bl ]] ; then chmod 755 $@ ; fi
	if [ -n "$($@_MODE)" ] ; then chmod $($@_MODE) $@ ; fi
%.js: %.jsp
	echo "/* This is a generated file */" > $@
	$(JS_COMPRESS) $< >> $@
%.css: %.cs
	echo "/* This is a generated file */" > $@
	$(CSS_COMPRESS) $< >> $@
install: $(installed)
ifneq ($(INSTALL_DIR),)
	mkdir -p $(INSTALL_DIR)
ifneq ($(installed),)
	cp -r $(installed) $(INSTALL_DIR)
endif
endif
ifneq ($(strip $(POST_INSTALL_COMMAND)),)
	$(POST_INSTALL_COMMAND)
endif
download: $(downloaded)
clean:
ifneq ($(cleandirs),)
	rm -rf $(cleandirs)
endif
ifneq ($(cleanfiles),)
	rm -f $(cleanfiles)
endif
cleaner distclean: clean
ifneq ($(CLEANERDIRS),)
	rm -rf $(CLEANERDIRS)
endif
ifneq ($(downloaded),)
	rm -rf $(downloaded)
endif
ifneq ($(cleanerfiles),)
	rm -f $(cleanerfiles)
endif
export PREFIX
endif # ifneq ($(rec_target),) else
endif # ifdef BUILD_PREFIX   else
