#!/bin/sh

# backup_rustprojects_from_crustde_to_win.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod
# run in Windows git-bash:
# MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/backup_rustprojects_from_crustde_to_win.sh

printf " \n"
printf "\033[0;33m    Bash script to backup from CRUSTDE ~/rustprojects/  \033[0m\n"
printf "\033[0;33m    to windows ~/rustprojects/crustde_rustprojects_backup/ \033[0m\n"
printf "\033[0;33m    Use 'sshadd' to store the SSH passphrase. \033[0m\n"
printf "\033[0;33m    Run this script in 'Windows git-bash':  \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/backup_rustprojects_from_crustde_to_win.sh \033[0m\n"
printf " \n"

printf "\033[0;33m    ssh rustdevuser@crustde 'tar -czvf crustde_rustprojects_backup.tar.gz --exclude="target" /home/rustdevuser/rustprojects/'  \033[0m\n"
ssh rustdevuser@crustde 'tar -czvf crustde_rustprojects_backup.tar.gz --exclude="target" /home/rustdevuser/rustprojects/'
printf "\033[0;33m    mkdir -p ~/rustprojects/crustde_rustprojects_backup \033[0m\n"
mkdir -p ~/rustprojects/crustde_rustprojects_backup
printf "\033[0;33m    MSYS_NO_PATHCONV=1 scp rustdevuser@crustde:~/crustde_rustprojects_backup.tar.gz ~/rustprojects/crustde_rustprojects_backup/crustde_rustprojects_backup.tar.gz \033[0m\n"
MSYS_NO_PATHCONV=1 scp rustdevuser@crustde:~/crustde_rustprojects_backup.tar.gz ~/rustprojects/crustde_rustprojects_backup/crustde_rustprojects_backup.tar.gz
printf "\033[0;33m    ssh rustdevuser@crustde 'rm crustde_rustprojects_backup.tar.gz' \033[0m\n"
ssh rustdevuser@crustde 'rm crustde_rustprojects_backup.tar.gz'

printf " \n"
