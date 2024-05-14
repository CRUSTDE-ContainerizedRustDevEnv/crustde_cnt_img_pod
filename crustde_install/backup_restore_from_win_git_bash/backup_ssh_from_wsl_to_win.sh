#!/bin/sh

# backup_ssh_from_wsl_to_win.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf " \n"
printf "\033[0;33m    Bash script to backup personal data from WSL ~/.ssh/  \033[0m\n"
printf "\033[0;33m    to windows ~/.ssh/wsl_ssh_backup/ \033[0m\n"
printf "\033[0;33m    Run this script in Windows git-bash. \033[0m\n"
printf "\033[0;33m    This backup of personal data can then survive the reset of the WSL2 virtual machine. \033[0m\n"
printf " \n"

printf "\033[0;33m    mkdir -p ~/.ssh/wsl_ssh_backup \033[0m\n"
mkdir -p ~/.ssh/wsl_ssh_backup

printf "\033[0;33m    tar -czvf wsl_ssh_backup.tar.gz /home/rustdevuser/.ssh/'  \033[0m\n"
tar -czvf ~/.ssh/wsl_ssh_backup/wsl_ssh_backup.tar.gz //wsl.localhost/Debian/home/luciano/.ssh

printf " \n"
