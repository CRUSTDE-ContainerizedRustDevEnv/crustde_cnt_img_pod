#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to prepare personal keys and setting for CRDE - Containerized Rust Development Environment. \033[0m"
echo "\033[0;33m    They will be stored in ~/.ssh \033[0m"
echo " "
# store_personal_keys_and_settings.sh
# repository: https://github.com/bestia-dev/docker_rust_development

# Copy the file personal_keys_and_settings_template.sh into ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
# There replace the words: 
# 'info@your.mail', 'your_name', 'github_com_git_ssh_1', 'bestia_dev_luciano_bestia_ssh_1', 'your_webserver'
# Call this script with 5 parameters.

# mandatory arguments
if [ ! "$1" ] || [ ! "$2" ] || [ ! "$3" ] || [ ! "$4" ] || [ ! "$5" ]; then
  echo "\033[0;31m    Error: All 5 arguments must be provided ! \033[0m"
  echo "    Usage:"
  echo "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_name github_com_git_ssh_1 bestia_dev_luciano_bestia_ssh_1 your_webserver \033[0m"
  exit 1;
fi

echo "info@your.mail: $1";
echo "your_name: $2";
echo "githubssh: $3";
echo "webserverssh: $4";
echo "your_webserver: $5";

echo " "

mkdir -p ~/.ssh/rust_dev_pod_keys/

cp personal_keys_and_settings_template.sh ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
cp sshadd_template.sh ~/.ssh/sshadd.sh
cp ssh_config_template ~/.ssh/rust_dev_pod_keys/config

sed -i.bak "s/info@your.mail/$1/g" ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/your_name/$2/g" ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/github_com_git_ssh_1/$3/g" ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/bestia_dev_luciano_bestia_ssh_1/$4/g" ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/your_webserver/$5/g" ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh

sed -i.bak "s/github_com_git_ssh_1/$3/g" ~/.ssh/sshadd.sh
sed -i.bak "s/bestia_dev_luciano_bestia_ssh_1/$4/g" ~/.ssh/sshadd.sh

sed -i.bak "s/your_webserver/$5/g" ~/.ssh/rust_dev_pod_keys/config

echo "\033[0;33m    Now you can install podman and setup the keys rust_dev_pod_keys."
echo "\033[0;32m sh podman_install_and_setup.sh \033[0m"

echo ""