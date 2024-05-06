#!/bin/sh

# tar_gzip_restore_from_win.sh
printf " \n"
printf "\033[0;33m    Script to restore the folder '~/rustprojects' in CRUSTDE container \033[0m\n"
printf "\033[0;33m    The backup file was transferer to Windows before upgrading the CRUSTDE container. \033[0m\n"
printf " \n"

if printf "$PWD\n" | grep -q --invert-match '/rustprojects$'; then
    printf "\033[0;31m    You are not in the correct directory '~/rustprojects' \033[0m\n"
    printf "\033[0;33m    Run the script as:  \033[0m\n"
    printf "\033[0;32m cd ~/rustprojects \033[0m\n"
    printf "\033[0;32m sh tar_gzip_restore_from_win.sh \033[0m\n"
    printf " \n"
    exit 1;
fi

if ! test -f rustprojects.tar.gz; then
    printf "\033[0;31m    The file rustprojects.tar.gz is not in this folder. \033[0m\n"
    printf "\033[0;33m    First in Windows git-bash, copy the 'rustprojects.tar.gz' to CRUSTDE container with this command: \033[0m\n"
    printf "\033[0;32m MSYS_NO_PATHCONV=1 scp ~/Downloads/rustprojects.tar.gz rustdevuser@crustde_rustdevuser:~/rustprojects/rustprojects.tar.gz \033[0m\n"
    exit 1;
fi

printf "\033[0;33m    tar --no-same-owner -xzv --strip-components=2 -C ~/rustprojects -f rustprojects.tar.gz \033[0m\n"
tar --no-same-owner -xzv --strip-components=3 -C ~/rustprojects -f rustprojects.tar.gz
printf " \n"
printf "\033[0;33m    Restore finished. Remove manually the old backup file: \033[0m\n"
printf "\033[0;32m rm rustprojects.tar.gz \033[0m\n"
printf "\033[0;33m    and 'git pull' from remote repository if anything has changed: \033[0m\n"
printf "\033[0;32m sshadd \033[0m\n"
printf "\033[0;32m sh pull_all.sh \033[0m\n"

printf " \n"
