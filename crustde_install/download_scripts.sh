#!/bin/sh

# in debian /bin/sh is dash and not bash. 
# There are some small differences ex.[] instead of [[ ]]

printf " \n"
printf "\033[0;33m    Bash script to download all scripts needed to setup the  \033[0m\n"
printf "\033[0;33m    CRUSTDE - Containerized Rust Development Environment \033[0m\n"

if printf "$PWD\n" | grep -q --invert-match '/rustprojects/crustde_install'; then
    printf " \n"
    printf "\033[0;31m    You are not in the correct directory ~/rustprojects/crustde_install \033[0m\n"
    printf "\033[0;33m    Run the commands to create the directory, cd and download the script. \033[0m\n"
    printf "\033[0;32m mkdir -p ~/rustprojects/crustde_install; \033[0m\n"
    printf "\033[0;32m cd ~/rustprojects/crustde_install; \033[0m\n"
    # -S show errors  -f fail-early -L redirect
    printf "\033[0;32m curl -Sf -L https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/download_scripts.sh --output download_scripts.sh; \033[0m\n"
    printf "\033[0;33m    You can read the bash script, it only creates dirs, download scripts and suggests what script to run next \033[0m\n"
    printf "\033[0;32m cat download_scripts.sh; \033[0m\n"
    printf "\033[0;33m    Run with sh that aliases to dash and not bash in Debian. \033[0m\n"
    printf "\033[0;32m sh download_scripts.sh; \033[0m\n"
else
    # download_scripts.sh
    # repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

    # empty the folder, because curl don't overwrite files
    rm -rf *

    printf " \n"
    printf "\033[0;33m    1. Downloading crustde_install.tar.gz from github \033[0m\n"
    printf "\033[0;33m    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/releases/latest/download/crustde_install.tar.gz --output crustde_install.tar.gz \033[0m\n"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/releases/latest/download/crustde_install.tar.gz --output crustde_install.tar.gz

    printf "\033[0;33m    2. Unpack the tar gzip \033[0m\n"
    printf "\033[0;33m    tar -xzv --strip-components=1 -f crustde_install.tar.gz \033[0m\n"
    tar -xzv --strip-components=1 -f crustde_install.tar.gz
    rm crustde_install.tar.gz

    # if both files already exist, don't need this step
    # beware the last ] needs a space before it or it does not work!
    if [ -f "$HOME/.ssh/crustde_pod_keys/personal_keys_and_settings.sh" ] && [ -f "$HOME/.ssh/crustde_pod_keys/sshadd.sh" ];
    then
        printf " \n"
        printf "\033[0;33m    3. The files with your personal data already exist: ~/.ssh/personal_keys_and_settings_template.sh and ~/.ssh/sshadd.sh \033[0m\n"
        printf "\033[0;33m    You don't need to recreate them. Unless your data changed. Then simply delete them and run this script again. \033[0m\n"
        printf "\033[0;33m    Now you can install podman and setup the keys crustde_rustdevuser_ssh_1 and crustde_pod_keys \033[0m\n"
        printf "\033[0;32m sh podman_install_and_setup.sh; \033[0m\n"
    else
        printf " \n" 
        printf "\033[0;33m    3. Inside ~/.ssh you will need 2 keys, one to access Github and the second to access your web server virtual machine. \033[0m\n"
        printf "\033[0;33m    You should already have these keys in your encrypted vault and you just need to copy them into the ~/.ssh folder. \033[0m\n"
        printf "\033[0;33m    I will call these keys github_com_bestia_dev_git_ssh_1v_git_ssh_1 and your_key_for_webserver_ssh_1, but you can have other names. \033[0m\n"
        printf "\033[0;33m    Modify accordingly to your locations and run these commands. \033[0m\n"
        printf "\033[0;32m mkdir ~/.ssh; \033[0m\n"
        printf "\033[0;32m chmod 700 ~/.ssh; \033[0m\n"
        printf "\033[0;33m   Copy your private and public key files into ~/.ssh \033[0m\n"
        
        printf " \n"
        printf "\033[0;33m    4. Now you can run the first script with 6 parameters.  \033[0m\n"
        printf "\033[0;33m    Change the parameters with your personal data. They are needed for the container.  \033[0m\n"
        printf "\033[0;33m    The files will be stored in ~/.ssh for later use. \033[0m\n"
        printf "\033[0;33m    Then follow the instructions from the next script. \033[0m\n"
        printf "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_gitname github_com_bestia_dev_git_ssh_1 your_webserver your_username your_key_for_webserver_ssh_1; \033[0m\n"
    fi
fi
printf "\n"
