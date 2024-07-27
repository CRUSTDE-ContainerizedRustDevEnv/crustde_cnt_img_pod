#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to prepare personal keys and setting for CRUSTDE - Containerized Rust Development Environment. \033[0m\n"
printf "\033[0;33m    They will be stored in ~/.ssh \033[0m\n"
printf " \n"
# store_personal_keys_and_settings.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

# Copy the file personal_keys_and_settings_template.sh into ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
# There replace the words: 
# info@your.mail your_gitname github_com_bestia_dev_git_ssh_1 your_webserver your_username your_key_for_webserver_ssh_1
# Call this script with 5 parameters.

# mandatory arguments
if [ ! "$1" ] || [ ! "$2" ] || [ ! "$3" ] || [ ! "$4" ] || [ ! "$5" ] || [ ! "$6" ]; then
  printf "\033[0;31m    Error: All 6 arguments must be provided ! \033[0m\n"
  printf "    Usage:\n"
  printf "\033[0;32m sh store_personal_keys_and_settings.sh info@your.mail your_gitname github_com_bestia_dev_git_ssh_1 your_webserver your_username your_key_for_webserver_ssh_1 \033[0m\n"
  exit 1;
fi

printf "info@your.mail: $1\n";
printf "your_gitname: $2\n";
printf "github_com_bestia_dev_git_ssh_1: $3\n";
printf "your_webserver: $4\n";
printf "your_username: $5\n";
printf "your_key_for_webserver_ssh_1: $6\n";
printf " \n"

mkdir -p ~/.ssh/crustde_pod_keys/

cp personal_keys_and_settings_template.sh ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
cp sshadd_template.sh ~/.ssh/crustde_pod_keys/sshadd.sh
cp ssh_config.ssh_config ~/.ssh/crustde_pod_keys/config

sed -i.bak "s/info@your.mail/$1/g" ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/your_gitname/$2/g" ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/github_com_bestia_dev_git_ssh_1/$3/g" ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/your_webserver/$4/g" ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/your_username/$5/g" ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh
sed -i.bak "s/your_key_for_webserver_ssh_1/$6/g" ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh

sed -i.bak "s/info@your.mail/$1/g" ~/.ssh/crustde_pod_keys/sshadd.sh
sed -i.bak "s/your_gitname/$2/g" ~/.ssh/crustde_pod_keys/sshadd.sh
sed -i.bak "s/github_com_bestia_dev_git_ssh_1/$3/g" ~/.ssh/crustde_pod_keys/sshadd.sh
sed -i.bak "s/your_webserver/$4/g" ~/.ssh/crustde_pod_keys/sshadd.sh
sed -i.bak "s/your_username/$5/g" ~/.ssh/crustde_pod_keys/sshadd.sh
sed -i.bak "s/your_key_for_webserver_ssh_1/$6/g" ~/.ssh/crustde_pod_keys/sshadd.sh

sed -i.bak "s/info@your.mail/$1/g" ~/.ssh/crustde_pod_keys/config
sed -i.bak "s/your_gitname/$2/g" ~/.ssh/crustde_pod_keys/config
sed -i.bak "s/github_com_bestia_dev_git_ssh_1/$3/g" ~/.ssh/crustde_pod_keys/config
sed -i.bak "s/your_webserver/$4/g" ~/.ssh/crustde_pod_keys/config
sed -i.bak "s/your_username/$5/g" ~/.ssh/crustde_pod_keys/config
sed -i.bak "s/your_key_for_webserver_ssh_1/$6/g" ~/.ssh/crustde_pod_keys/config

printf "\033[0;33m    Now you can install podman and setup the keys crustde_pod_keys.\n"
printf "\033[0;32m sh podman_install_and_setup.sh \033[0m\n"

printf "\n"