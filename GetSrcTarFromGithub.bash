#!/bin/bash

################### CONFIGURE ###############################
UHD_TAG=v3.14.0.0

# if not set it will not use the sha512 sum and tell you it
SHA512SUM=

############################################################


# This gets a tarball from github.

#Usage: GetSrcTarFromGithub user package tag tarname [sha512]

function GetSrcTarFromGithub()
{
    [ -n "$4" ] || exit 1

    local path="$1/$2"
    local tag="$3"
    local tarfile=$4.tar.gz

    if [ -e "$tarfile" ] && [ -n "$5" ] ; then
        if ! echo "$5  $tarfile" | sha512sum -c ; then
            set +x
            echo "You have \"$tarfile\" with a bad sha512 sum"
            exit 1
        else
            # success
            set +x
            echo "We have the tar file \"$tarfile\" already"
            exit 0
        fi
    fi

    # This gets a tarball file from github for the package
    wget --no-check-certificate -O $tarfile https://github.com/$path/tarball/$tag

    if [ -n "$5" ] ; then
        set +e
        # Check that the file has a good SHA512 sum
        if ! echo "$5  $tarfile" | sha512sum -c ; then
            set +x
            echo "You have $tarfile with a bad sha512 sum"
            exit 1 # FAIL
        fi
    else
        # Just report the SHA512 sum
        sha512sum $tarfile
    fi
    # Success
}

