#!/bin/sh

printf "\033[0;33m    Script to tar gzip the rustprojects from CRUSTDE \033[0m\n"
printf "\033[0;33m    so I can move the file to Windows \033[0m\n"
printf "\033[0;33m    before I upgrade the container. \033[0m\n"
printf "\033[0;33m    Later I can restore it back to CRUSTDE container. \033[0m\n"

printf "\033[0;32mtar -czvf  rustprojects.tar.gz --exclude="target"  $HOME/rustprojects/ \033[0m\n"
tar -czvf  rustprojects.tar.gz --exclude="target"  $HOME/rustprojects/

printf "\033[0;33m    Now in Windows, copy the rustprojects.tar.gz from CRUSTDE container. \033[0m\n"

