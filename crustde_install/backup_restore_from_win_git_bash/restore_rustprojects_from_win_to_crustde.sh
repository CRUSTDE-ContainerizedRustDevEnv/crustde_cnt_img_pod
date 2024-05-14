#!/bin/sh

# restore_rustprojects_from_win_to_crustde.sh
printf " \n"
printf "\033[0;33m    Script to restore the folder '~/rustprojects' in CRUSTDE container \033[0m\n"
printf "\033[0;33m    The backup file was transferer to Windows before upgrading the CRUSTDE container. \033[0m\n"
printf " \n"

printf "\033[0;33m    MSYS_NO_PATHCONV=1 scp rustdevuser@crustde_rustdevuser:~/rustprojects/crustde_rustprojects_backup/crustde_rustprojects_backup.tar.gz ~/crustde_rustprojects_backup.tar.gz \033[0m\n"
MSYS_NO_PATHCONV=1 scp rustdevuser@crustde_rustdevuser:~/rustprojects/crustde_rustprojects_backup/crustde_rustprojects_backup.tar.gz ~/crustde_rustprojects_backup.tar.gz

printf "\033[0;33m    ssh rustdevuser@crustde_rustdevuser 'tar --no-same-owner -xzv --strip-components=3 -C ~/rustprojects -f ~/crustde_rustprojects_backup.tar.gz' \033[0m\n"
ssh rustdevuser@crustde_rustdevuser 'tar --no-same-owner -xzv --strip-components=3 -C ~/rustprojects -f ~/crustde_rustprojects_backup.tar.gz'

printf "\033[0;33m    ssh rustdevuser@crustde_rustdevuser 'rm ~/crustde_rustprojects_backup.tar.gz' \033[0m\n"
ssh rustdevuser@crustde_rustdevuser 'rm ~/crustde_rustprojects_backup.tar.gz'

printf " \n"
printf "\033[0;33m    Restore finished. Inside CRUSTDE run the sshadd and pull_all scripts: \033[0m\n"
printf "\033[0;32m sshadd \033[0m\n"
printf "\033[0;32m sh pull_all.sh \033[0m\n"
printf " \n"
