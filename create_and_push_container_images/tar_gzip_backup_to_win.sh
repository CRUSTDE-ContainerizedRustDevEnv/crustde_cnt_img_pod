#!/bin/sh

# tar_gzip_backup_to_win.sh
printf " \n"
printf "\033[0;33m    Script to backup the folder '~/rustprojects' in CRUSTDE container \033[0m\n"
printf " \n"

if printf "$PWD\n" | grep -q --invert-match '/rustprojects$'; then
    printf "\033[0;31m    You are not in the correct directory '~/rustprojects' \033[0m\n"
    printf "\033[0;33m    Run the script as:  \033[0m\n"
    printf "\033[0;32m cd ~/rustprojects \033[0m\n"
    printf "\033[0;32m sh tar_gzip_backup_to_win.sh \033[0m\n"
    printf " \n"
  exit 1;
fi

printf "\033[0;33m    tar -czvf  rustprojects.tar.gz --exclude="target"  $HOME/rustprojects/ \033[0m\n"
tar -czvf  rustprojects.tar.gz --exclude="target"  $HOME/rustprojects/

printf "\033[0;33m    Now in Windows git-bash, copy the 'rustprojects.tar.gz' from CRUSTDE container with this command: \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 scp rustdevuser@crustde_rustdevuser:~/rustprojects/rustprojects.tar.gz ~/Downloads/rustprojects.tar.gz \033[0m\n"
printf " \n"
