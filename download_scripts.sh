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
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/personal_keys_and_settings_template.sh --output ~/.ssh/personal_keys_and_settings_template.sh
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/sshadd_template.sh --output ~/.ssh/sshadd_template.sh
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/store_personal_keys_and_settings.sh --output ~/.ssh/store_personal_keys_and_settings.sh
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/backup_personal_data_from_wsl_to_win.sh --output ~/.ssh/backup_personal_data_from_wsl_to_win.sh
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/restore_personal_data_from_win_to_wsl.sh --output ~/.ssh/restore_personal_data_from_win_to_wsl.sh

curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/podman_install_and_setup.sh --output ~/.ssh/podman_install_and_setup.sh

curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output ~/.ssh/rust_dev_pod_create.sh
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output ~/.ssh/rust_dev_pod_after_reboot.sh

curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_create.sh --output ~/.ssh/rust_pg_dev_pod_create.sh
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_after_reboot.sh --output ~/.ssh/rust_pg_dev_pod_after_reboot.sh

echo "\033[0;33m    4. Change your directory \033[0m"
echo "\033[0;33m cd ~/rustprojects/docker_rust_development_install \033[0m"

echo "\033[0;33m    5. Run the first script with 4 parameters to store your personal data needed for the container \033[0m"
echo "\033[0;33m sh store_personal_keys_and_settings.sh info@your.mail your_name githubssh_filename webserverssh_filename \033[0m"