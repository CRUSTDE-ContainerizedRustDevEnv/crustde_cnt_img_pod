#!/usr/bin/env bash

echo " "
echo "\033[0;33m    Bash script to download all scripts needed to setup Rust development environment inside a docker container. \033[0m"
echo "\033[0;33m    run with \033[0m"
# -s silent  -L redirect
echo "\033[0;33m    curl -s -L https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/download_scripts.sh | sh \033[0m"
# download_scripts.sh
# repository: https://github.com/bestia-dev/docker_rust_development

echo "\033[0;33m    1. Create dir ~/rustprojects/docker_rust_development_install \033[0m"
mkdir -p ~/rustprojects/docker_rust_development_install
cd ~/rustprojects/docker_rust_development_install

echo "\033[0;33m    2. Download all scripts from github \033[0m"
echo " personal_keys_and_settings_template"
# -s silent  -L redirect -S show errors
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/personal_keys_and_settings_template.sh --output personal_keys_and_settings_template.sh
echo " sshadd_template"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/sshadd_template.sh --output sshadd_template.sh
echo " store_personal_keys_and_settings"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/store_personal_keys_and_settings.sh --output store_personal_keys_and_settings.sh
echo " backup_personal_data_from_wsl_to_win"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/backup_personal_data_from_wsl_to_win.sh --output backup_personal_data_from_wsl_to_win.sh
echo " restore_personal_data_from_win_to_wsl"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/restore_personal_data_from_win_to_wsl.sh --output restore_personal_data_from_win_to_wsl.sh

echo " podman_install_and_setup"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/podman_install_and_setup.sh --output podman_install_and_setup.sh

echo " rust_dev_pod_create"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/rust_dev_pod_create.sh --output rust_dev_pod_create.sh
echo " rust_dev_pod_after_reboot"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh

echo " rust_pg_dev_pod_create"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/rust_pg_dev_pod_create.sh --output rust_pg_dev_pod_create.sh
echo " rust_pg_dev_pod_after_reboot"
curl -L -sS https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/rust_pg_dev_pod_after_reboot.sh --output rust_pg_dev_pod_after_reboot.sh

echo ""
echo "\033[0;33m    3. Now run this command in bash to change your working directory \033[0m"
echo "\033[0;32m cd ~/rustprojects/docker_rust_development_install \033[0m"

# if both files already exist, don't need this step
if [ test -f "~/.ssh/personal_keys_and_settings_template.sh" && test -f "~/.ssh/sshadd.sh" ]; then
    echo "\033[0;33m    4. The files with your personal data already exist: ~/.ssh/personal_keys_and_settings_template.sh and ~/.ssh/sshadd.sh \033[0m"
    echo "\033[0;33m    You don't need to recreate them. Unless your data changed. Then simply delete them and run this script again. \033[0m"
    echo "Now you can create your pod.";
    echo "You can choose between 3 pods:";
    echo "1. pod with rust and vscode";
    echo "      sh ~/rustprojects/docker_rust_development_install/pod_with_rust_vscode/rust_dev_pod_create.sh";
    echo "2. pod with rust, postgres and vscode";
    echo "      sh ~/rustprojects/docker_rust_development_install/pod_with_rust_pg_vscode/rust_pg_dev_pod_create.sh";
    echo "3. pod with rust, typescript and vscode";
    echo "      sh ~/rustprojects/docker_rust_development_install/pod_with_rust__ts_vscode/rust_ts_dev_pod_create.sh";
else 
    echo "\033[0;33m    4. Now run the first script with 4 parameters.  \033[0m"
    echo "\033[0;33m    Change the parameters with your personal data. They are needed for the container.  \033[0m"
    echo "\033[0;33m    The files will be stored in ~/.ssh for later use. \033[0m"
    echo "\033[0;33m    Then follow the instructions from the next script. \033[0m"
    echo "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_name githubssh_filename webserverssh_filename \033[0m"
fi

echo ""
echo ""
