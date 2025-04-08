#!/bin/sh

# backup_ssh_from_crustde_to_win.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod
# run in Windows git-bash:
# sh backup_ssh_from_crustde_to_win.sh

printf " \n"
printf "\033[0;33m    Bash script to backup from CRUSTDE ~/.ssh/  \033[0m\n"
printf "\033[0;33m    to windows ~/.ssh/crustde_ssh_backup/ \033[0m\n"
printf "\033[0;33m    Use 'sshadd' to store the SSH passphrase. \033[0m\n"
printf "\033[0;33m    Run this script in 'Windows git-bash':  \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m sh backup_ssh_from_crustde_to_win.sh \033[0m\n"
printf " \n"

printf "\033[0;33m    mkdir -p ~/.ssh/crustde_ssh_backup \033[0m\n"
mkdir -p ~/.ssh/crustde_ssh_backup
cd ~/.ssh/crustde_ssh_backup

# put current date as yyyy-mm-dd in $date
date=$(date '+%Y-%m-%d')

printf "\033[0;33m    ssh rustdevuser@crustde 'date=$(date '+%Y-%m-%d'); tar -C /home/rustdevuser/.ssh -czvf ${date}_crustde_ssh_backup.tar.gz .'  \033[0m\n"
ssh rustdevuser@crustde 'date=$(date '+%Y-%m-%d'); tar -C /home/rustdevuser/.ssh -czvf ${date}_crustde_ssh_backup.tar.gz .'

printf "\033[0;33m    MSYS_NO_PATHCONV=1 scp -p rustdevuser@crustde:${date}_crustde_ssh_backup.tar.gz ~/.ssh/crustde_ssh_backup/${date}_crustde_ssh_backup.tar.gz \033[0m\n"
MSYS_NO_PATHCONV=1 scp -p rustdevuser@crustde:${date}_crustde_ssh_backup.tar.gz ~/.ssh/crustde_ssh_backup/${date}_crustde_ssh_backup.tar.gz

printf "\033[0;33m    ssh rustdevuser@crustde 'date=$(date '+%Y-%m-%d'); rm ${date}_crustde_ssh_backup.tar.gz' \033[0m\n"
ssh rustdevuser@crustde 'date=$(date '+%Y-%m-%d'); rm ${date}_crustde_ssh_backup.tar.gz'

printf " \n"
