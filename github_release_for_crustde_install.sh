#!/bin/sh

# github_release_for_crustde_inastall.sh

printf " \n"
printf "\033[0;33m    Bash script to create the file to upload to GitHub Release from the /crustde_install/ directory. \033[0m\n"

printf "\033[0;33m    tar -zcvf crustde_install.tar.gz crustde_install \033[0m\n"
tar -zcvf crustde_install.tar.gz crustde_install

printf "\033[0;33m    Now create a Release on GitHub and upload the file 'crustde_install.tar.gz'. \033[0m\n"
printf "\033[0;32m https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/releases \033[0m\n"
