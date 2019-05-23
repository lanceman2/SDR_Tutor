# SDR_Tutor

My notes on software defined radios (SDR).


## Ports

Debian GNU/Linux 9 and like.


## Building

This project depends on other software projects, so we automate the
process of downloading the dependences.

You may need software installed that are part of the operating systems
(OS) managed packages and so on a Debian system you may need to run things
like:
```apt-get install make wget git```
and so on.  You are on your own figuring out what OS packages you need.

Next run
```./bootstrap```
to get a the quickbuild.make GNU make file from the web.

Next run
```make download```
to get other needed files from the web.

Next run
```make```
to generate this projects files.

Next browse the HTML files, like for example run:
```firefox index.html```
Assuming you have firefox installed, have a look at the browser.


## Optionally Install

Install the HTML, javaScript, CSS, and other web files by
running:
```make install PREFIX=MY_PREFIX```
where MY_PREFIX is a directory where the web files will be copied to.
The, thusly, installed files are complete and to not require the source
files in order to use them.

Enjoy.
