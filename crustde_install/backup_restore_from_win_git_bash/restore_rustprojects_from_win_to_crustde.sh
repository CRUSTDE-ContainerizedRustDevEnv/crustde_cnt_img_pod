#!/bin/sh

# restore_rustprojects_from_win_to_crustde.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod
# run in Windows git-bash:
# MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/restore_rustprojects_from_win_to_crustde.sh

printf " \n"
printf "\033[0;33m    Script to restore the folder '~/rustprojects' in CRUSTDE container \033[0m\n"
printf "\033[0;33m    The backup file was transferer to Windows before upgrading the CRUSTDE container. \033[0m\n"
printf "\033[0;33m    Use 'sshadd' to store the SSH passphrase. \033[0m\n"
printf "\033[0;33m    Run this script in 'Windows git-bash':  \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 sh //wsl.localhost/Debian/home/luciano/rustprojects/crustde_install/backup_restore_from_win_git_bash/restore_rustprojects_from_win_to_crustde.sh \033[0m\n"
printf " \n"

printf "\033[0;33m    MSYS_NO_PATHCONV=1 scp ~/rustprojects/crustde_rustprojects_backup/crustde_rustprojects_backup.tar.gz rustdevuser@crustde:~/crustde_rustprojects_backup.tar.gz \033[0m\n"
MSYS_NO_PATHCONV=1 scp ~/rustprojects/crustde_rustprojects_backup/crustde_rustprojects_backup.tar.gz rustdevuser@crustde:~/crustde_rustprojects_backup.tar.gz

printf "\033[0;33m    ssh rustdevuser@crustde 'tar --no-same-owner -xzv --strip-components=3 -C ~/rustprojects -f ~/crustde_rustprojects_backup.tar.gz' \033[0m\n"
ssh rustdevuser@crustde 'tar --no-same-owner -xzv --strip-components=3 -C ~/rustprojects -f ~/crustde_rustprojects_backup.tar.gz'

printf "\033[0;33m    ssh rustdevuser@crustde 'rm ~/crustde_rustprojects_backup.tar.gz' \033[0m\n"
ssh rustdevuser@crustde 'rm ~/crustde_rustprojects_backup.tar.gz'

printf " \n"
printf "\033[0;33m    Restore finished. \033[0m\n"
printf "\033[0;33m    Run VSCode to connect to CRUSTDE rustprojects: \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 code --remote ssh-remote+crustde /home/rustdevuser/rustprojects  \033[0m\n"

printf "\033[0;33m    In VSCode terminal pull all from remote repository: \033[0m\n"
printf "\033[0;32m sshadd crustde \033[0m\n"
printf "\033[0;32m sh pull_all.sh \033[0m\n"
printf " \n"
