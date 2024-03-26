#!/bin/sh

# in debian /bin/sh is dash and not bash. 
# There are some small differences ex.[] instead of [[ ]]

echo " "
echo "\033[0;33m    Bash script to download all scripts needed to setup the  \033[0m"
echo "\033[0;33m    CRUSTDE - Containerized Rust Development Environment \033[0m"

if echo "$PWD" | grep -q '/rustprojects/crustde_install'; then
    # download_scripts.sh
    # repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

    # empty the folder, because curl don't overwrite files
    rm -rf *

    echo " "
    echo "\033[0;33m    1. Creating dir structure in ~/rustprojects/crustde_install \033[0m"
    
    mkdir -p pod_with_rust_vscode

    echo " "
    echo "\033[0;33m    2. Downloading all scripts from github \033[0m"
    echo " 1. personal_keys_and_settings_template.sh"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/personal_keys_and_settings_template.sh --output personal_keys_and_settings_template.sh
    echo " 2. sshadd_template.sh"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/sshadd_template.sh --output sshadd_template.sh
    echo " 3. ssh_config.ssh_config"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/ssh_config.ssh_config --output ssh_config.ssh_config
    echo " 4. store_personal_keys_and_settings.sh"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/store_personal_keys_and_settings.sh --output store_personal_keys_and_settings.sh
    echo " 5. etc_ssh_sshd_config.conf"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf
    echo " 6. podman_install_and_setup.sh"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/podman_install_and_setup.sh --output podman_install_and_setup.sh
    echo " 7. crustde_pod_after_reboot.sh"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/crustde_pod_after_reboot.sh --output crustde_pod_after_reboot.sh
    echo " 8. crustde_install.md"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/crustde_install.md --output crustde_install.md
    echo " 9. pod_with_rust_vscode/crustde_pod_create.sh"
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/pod_with_rust_vscode/crustde_pod_create.sh --output pod_with_rust_vscode/crustde_pod_create.sh    
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/pod_with_rust_vscode/etc_squid_squid.conf --output pod_with_rust_vscode/etc_squid_squid.conf
    curl -L -sSf https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/pod_with_rust_vscode/copy_squid_config_and_restart_cnt.sh --output pod_with_rust_vscode/copy_squid_config_and_restart_cnt.sh

    # if both files already exist, don't need this step
    # beware the last ] needs a space before it or it does not work!
    if [ -f "$HOME/.ssh/crustde_pod_keys/personal_keys_and_settings.sh" ] && [ -f "$HOME/.ssh/crustde_pod_keys/sshadd.sh" ];
    then
        echo " "
        echo "\033[0;33m    3. The files with your personal data already exist: ~/.ssh/personal_keys_and_settings_template.sh and ~/.ssh/sshadd.sh \033[0m"
        echo "\033[0;33m    You don't need to recreate them. Unless your data changed. Then simply delete them and run this script again. \033[0m"
        echo "\033[0;33m    Now you can install podman and setup the keys crustde_rustdevuser_ssh_1 and crustde_pod_keys \033[0m"
        echo "\033[0;32m sh podman_install_and_setup.sh; \033[0m"
    else
        echo " " 
        echo "\033[0;33m    3. Inside ~/.ssh you will need 2 keys, one to access Github and the second to access your web server virtual machine. \033[0m"
        echo "\033[0;33m    You should already have these keys in your encrypted vault and you just need to copy them into the ~/.ssh folder. \033[0m"
        echo "\033[0;33m    I will call these keys github_com_git_ssh_1 and your_key_for_webserver_ssh_1, but you can have other names. \033[0m"
        echo "\033[0;33m    Modify accordingly to your locations and run these commands. \033[0m"
        echo "\033[0;32m mkdir ~/.ssh; \033[0m"
        echo "\033[0;32m chmod 700 ~/.ssh; \033[0m"
        echo "\033[0;33m   Copy your private and public key files into ~/.ssh \033[0m"
        
        echo " "
        echo "\033[0;33m    4. Now you can run the first script with 6 parameters.  \033[0m"
        echo "\033[0;33m    Change the parameters with your personal data. They are needed for the container.  \033[0m"
        echo "\033[0;33m    The files will be stored in ~/.ssh for later use. \033[0m"
        echo "\033[0;33m    Then follow the instructions from the next script. \033[0m"
        echo "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_gitname github_com_git_ssh_1 your_webserver your_username your_key_for_webserver_ssh_1; \033[0m"
    fi
else
    echo " "
    echo "\033[0;33m    You are not in the correct directory ~/rustprojects/crustde_install \033[0m"
    echo "\033[0;33m    Run the commands to create the directory, cd and download the script. \033[0m"
    echo "\033[0;32m mkdir -p ~/rustprojects/crustde_install; \033[0m"
    echo "\033[0;32m cd ~/rustprojects/crustde_install; \033[0m"
    # -S show errors  -f fail-early -L redirect
    echo "\033[0;32m curl -Sf -L https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/raw/main/crustde_install/download_scripts.sh --output download_scripts.sh; \033[0m"
    echo "\033[0;33m    You can read the bash script, it only creates dirs, download scripts and suggests what script to run next \033[0m"
    echo "\033[0;32m cat download_scripts.sh; \033[0m"
    echo "\033[0;33m    Run with sh that aliases to dash and not bash in Debian. \033[0m"
    echo "\033[0;32m sh download_scripts.sh; \033[0m"
fi
echo ""
