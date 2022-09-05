#!/usr/bin/env bash

echo " "
echo "\033[0;33m    Bash script to download all scripts needed to setup Rust development environment inside a docker container. \033[0m"

# download_scripts.sh
# repository: https://github.com/bestia-dev/docker_rust_development

echo " "
echo "\033[0;33m    1. We need curl to download the scripts. \033[0m"
echo "\033[0;33m sudo apt install -y curl \033[0m"
sudo apt install -y curl

echo "\033[0;33m    2. Create dir ~/rustprojects/docker_rust_development_install \033[0m"
mkdir -p ~/rustprojects/docker_rust_development_install
cd ~/rustprojects/docker_rust_development_install

echo "\033[0;33m    3. Download all scripts \033[0m"
echo " personal_keys_and_settings_template"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/personal_keys_and_settings_template.sh --output personal_keys_and_settings_template.sh
echo " sshadd_template"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/sshadd_template.sh --output sshadd_template.sh
echo " store_personal_keys_and_settings"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/store_personal_keys_and_settings.sh --output store_personal_keys_and_settings.sh
echo " backup_personal_data_from_wsl_to_win"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/backup_personal_data_from_wsl_to_win.sh --output backup_personal_data_from_wsl_to_win.sh
echo " restore_personal_data_from_win_to_wsl"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/restore_personal_data_from_win_to_wsl.sh --output restore_personal_data_from_win_to_wsl.sh

echo " podman_install_and_setup"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/podman_install_and_setup.sh --output podman_install_and_setup.sh

echo " rust_dev_pod_create"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh
echo " rust_dev_pod_after_reboot"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh

echo " rust_pg_dev_pod_create"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_create.sh --output rust_pg_dev_pod_create.sh
echo " rust_pg_dev_pod_after_reboot"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_after_reboot.sh --output rust_pg_dev_pod_after_reboot.sh

echo ""
echo "\033[0;33m    4. Now run this command in bash to change your working directory \033[0m"
echo "\033[0;32m cd ~/rustprojects/docker_rust_development_install \033[0m"

# if already exist, don't need this step
echo "\033[0;33m    5. Now run the first script with 4 parameters.  \033[0m"
echo "\033[0;33m    Change the parameters with your personal data. They are needed for the container.  \033[0m"
echo "\033[0;33m    They will be stored in ~/.ssh \033[0m"
echo "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_name githubssh_filename webserverssh_filename \033[0m"