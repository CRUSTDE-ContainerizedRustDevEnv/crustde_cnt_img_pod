#!/bin/sh

# in debian /bin/sh is dash and not bash. 
# There are some small differences ex.[] instead of [[ ]]

echo " "
echo "\033[0;33m    Bash script to download all scripts needed to setup Rust development environment inside a docker container. \033[0m"
echo "\033[0;33m    run with sh that aliases to dash and not bash in Debian: \033[0m"
# -s silent -S show errors  -f fail-early -L redirect
echo "\033[0;32m curl -sSf -L https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/download_scripts.sh | sh \033[0m"
# download_scripts.sh
# repository: https://github.com/bestia-dev/docker_rust_development

echo "\033[0;33m    1. Creating dir ~/rustprojects/docker_rust_development_install \033[0m"
mkdir -p ~/rustprojects/docker_rust_development_install
cd ~/rustprojects/docker_rust_development_install
mkdir -p pod_with_rust_vscode
mkdir -p pod_with_rust_pg_vscode
mkdir -p pod_with_rust_ts_vscode
mkdir -p pod_with_rust_ts_vscode_with_volume

echo "\033[0;33m    2. Downloading all scripts from github \033[0m"

echo " 1. personal_keys_and_settings_template.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/personal_keys_and_settings_template.sh --output personal_keys_and_settings_template.sh
echo " 2. sshadd_template.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/sshadd_template.sh --output sshadd_template.sh
echo " 3. store_personal_keys_and_settings.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/store_personal_keys_and_settings.sh --output store_personal_keys_and_settings.sh
echo " 4. backup_personal_data_from_wsl_to_win.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/backup_personal_data_from_wsl_to_win.sh --output backup_personal_data_from_wsl_to_win.sh
echo " 5. restore_personal_data_from_win_to_wsl.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/restore_personal_data_from_win_to_wsl.sh --output restore_personal_data_from_win_to_wsl.sh

echo " 6. etc_ssh_sshd_config.conf"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf

echo " 7. podman_install_and_setup.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/podman_install_and_setup.sh --output podman_install_and_setup.sh

echo " 8. pod_with_rust_vscode/rust_dev_pod_create.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/pod_with_rust_vscode/rust_dev_pod_create.sh --output pod_with_rust_vscode/rust_dev_pod_create.sh    

echo " 9. pod_with_rust_pg_vscode/rust_dev_pod_create.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/pod_with_rust_pg_vscode/rust_dev_pod_create.sh --output pod_with_rust_pg_vscode/rust_dev_pod_create.sh

echo " 10. pod_with_rust_pg_vscode/rust_dev_pod_create.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/pod_with_rust_ts_vscode/rust_dev_pod_create.sh --output pod_with_rust_ts_vscode/rust_dev_pod_create.sh

echo " 11. pod_with_rust_pg_vscode_with_volume/rust_dev_pod_create.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/pod_with_rust_pg_vscode_with_volume/rust_dev_pod_create.sh --output pod_with_rust_ts_vscode_with_volume/rust_dev_pod_create.sh

echo " 12. rust_dev_pod_after_wsl_reboot.sh"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/rust_dev_pod_after_wsl_reboot.sh --output rust_dev_pod_after_wsl_reboot.sh

echo " 13. docker_rust_development_install.md"
curl -L -sSf https://github.com/bestia-dev/docker_rust_development/raw/main/download_prepare_install_podman_with_personal_data/docker_rust_development_install.md --output docker_rust_development_install.md

echo ""
echo "\033[0;33m    3. Now you can run this command to change your working directory \033[0m"
echo "\033[0;32m cd ~/rustprojects/docker_rust_development_install \033[0m"

# if both files already exist, don't need this step
# beware the last ] needs a space before it or it does not work!
if [ -f "$HOME/.ssh/personal_keys_and_settings.sh" ] && [ -f "$HOME/.ssh/sshadd.sh" ];
then
    echo "\033[0;33m    4. The files with your personal data already exist: ~/.ssh/personal_keys_and_settings_template.sh and ~/.ssh/sshadd.sh \033[0m"
    echo "\033[0;33m    You don't need to recreate them. Unless your data changed. Then simply delete them and run this script again."
    echo "\033[0;33m    Now you can install podman and setup the keys rustdevuser_key and rust_dev_pod_keys and."
    echo "\033[0;32m sh podman_install_and_setup.sh \033[0m"
else 
    echo "\033[0;33m    4. Now you can run the first script with 4 parameters.  \033[0m"
    echo "\033[0;33m    Change the parameters with your personal data. They are needed for the container.  \033[0m"
    echo "\033[0;33m    The files will be stored in ~/.ssh for later use. \033[0m"
    echo "\033[0;33m    Then follow the instructions from the next script. \033[0m"
    echo "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_name githubssh_filename webserverssh_filename \033[0m"
fi

echo ""
