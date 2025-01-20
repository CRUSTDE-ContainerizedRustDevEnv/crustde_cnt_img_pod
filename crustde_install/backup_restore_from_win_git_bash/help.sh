#!/bin/sh

# help.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod
# Run in Debian:
# sh ~/rustprojects/crustde_install/backup_restore_from_win_git_bash/help.sh
# Run in 'Windows git-bash':
# MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/help.sh

printf " \n"
printf "\033[0;33m    Help to run backup and restore bash scripts for CRUSTDE. \033[0m\n"
printf "\033[0;33m    Use ssh to save credentials for access to CRUSTDE. \033[0m\n"
printf " \n"
printf "\033[0;33m    Run backup scripts in 'Windows git-bash':  \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/backup_rustprojects_from_crustde_to_win.sh \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/backup_ssh_from_crustde_to_win.sh \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/backup_ssh_from_wsl_to_win.sh \033[0m\n"
printf " \n"
printf "\033[0;33m    Run restore script in 'Windows git-bash':  \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/restore_rustprojects_from_win_to_crustde.sh \033[0m\n"
printf " \n"