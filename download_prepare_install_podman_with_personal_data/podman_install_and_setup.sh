#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to install Podman and setup for rust_dev_pod for development in Rust with VSCode. \033[0m"

# podman_install_and_setup.sh
# repository: https://github.com/bestia-dev/docker_rust_development

echo " " 
echo "\033[0;33m    Prerequisites: Win10+WSL2 or Debian, VSCode\033[0m"
echo " " 

echo " " 
echo "\033[0;33m    1. Create 2 SSH keys, one for the 'SSH server' identity 'host key' of the container and the other for the identity of 'rustdevuser'.  \033[0m"
echo "\033[0;33m    This is done only once. To avoid old crypto-algorithms I will force the new 'ed25519'. \033[0m"

echo "\033[0;33m    mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh \033[0m"
mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh

echo "\033[0;33m    If keys do not exist then generate them. \033[0m"
if [ ! -f ~/.ssh/rustdevuser_key ]; then
  echo "\033[0;33m    generate user key \033[0m"
  echo "\033[0;33m    give it a passphrase and remember it, you will need it \033[0m"
  echo "\033[0;33m    ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C 'rustdevuser@rust_dev_pod' \033[0m"
  ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C "rustdevuser@rust_dev_pod \033[0m"
else 
  echo "\033[0;33m    Key rustdevuser_key already exists. \033[0m"
fi

if [ ! -f ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then
  echo "\033[0;33m    generate host key \033[0m"
  echo "\033[0;33m    ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys \033[0m"
  ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys
else 
  echo "\033[0;33m    Key ssh_host_ed25519_key already exists. \033[0m"
fi
# check
#echo "\033[0;33m    ls -l ~/.ssh | grep 'rustdevuser' \033[0m"
#ls -l ~/.ssh | grep "rustdevuser"
#echo "\033[0;33m    ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh \033[0m"
#ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh

echo " " 
echo "\033[0;33m    2. Install Podman in 'WSL2 terminal': \033[0m"
echo "\033[0;33m    sudo apt install -y podman \033[0m"
sudo apt install -y podman
echo "\033[0;33m    podman --version \033[0m"
podman --version
# podman 3.0.1

echo " "
echo "\033[0;33m    3. Podman needs a slight adjustment because it is inside WSL2. \033[0m"
if [ -f $HOME/.config/containers/containers.conf ]; then
  echo "\033[0;33m    $HOME/.config/containers/containers.conf already exists. \033[0m"
else
  echo "\033[0;33m    mkdir $HOME/.config/containers \033[0m"
  mkdir $HOME/.config/containers
  echo '  [engine]
  cgroup_manager = "cgroupfs"
  events_logger = "file"'
  echo "\033[0;33m    | sudo tee -a $HOME/.config/containers/containers.conf \033[0m"
  echo '[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"' | sudo tee -a $HOME/.config/containers/containers.conf
fi

echo " "
echo "\033[0;33m    4. Docker hub uses https with TLS/SSL encryption. The server certificate cannot be recognized by podman. We will add it to the local system simply by using curl once. \033[0m"
echo "\033[0;33m    curl -s -v https://registry-1.docker.io/v2/ -o /dev/null \033[0m"
curl -s -v https://registry-1.docker.io/v2/ -o /dev/null
echo "\033[0;33m    That's it. The server certificate is now locally recognized. \033[0m"

echo " "
echo "\033[0;33m    5. Download bash script and config files: \033[0m"
echo "\033[0;33m    mkdir -p ~/rustprojects/docker_rust_development \033[0m"
mkdir -p ~/rustprojects/docker_rust_development
echo "\033[0;33m    cd ~/rustprojects/docker_rust_development \033[0m"
cd ~/rustprojects/docker_rust_development
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh
echo "\033[0;33m    Also the newer scripts for pod with postgres \033[0m"
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_create.sh --output rust_pg_dev_pod_create.sh \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_create.sh --output rust_pg_dev_pod_create.sh
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_after_reboot.sh --output rust_pg_dev_pod_after_reboot.sh \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_pg_dev_pod_after_reboot.sh --output rust_pg_dev_pod_after_reboot.sh

#echo "\033[0;33m    check the downloaded files \033[0m"
#echo "\033[0;33m    ls -l ~/rustprojects/docker_rust_development \033[0m"
# ls -l ~/rustprojects/docker_rust_development
#echo "\033[0;33m    cat etc_ssh_sshd_config.conf \033[0m"
#cat etc_ssh_sshd_config.conf
#echo "\033[0;33m    cat rust_dev_pod_create.sh \033[0m"
#cat rust_dev_pod_create.sh
#echo "\033[0;33m    cat rust_dev_pod_after_reboot.sh \033[0m"
#cat rust_dev_pod_after_reboot.sh

echo " "
echo "\033[0;33m    6. Prepare the config file for VSCode SSH: \033[0m"
echo "\033[0;33m    Check if the word rust_dev_vscode_cnt already exists in the config file. \033[0m"
if grep -q "Host rust_dev_vscode_cnt" "~/.ssh/config"; then
  echo "\033[0;33m    VSCode config for SSH already exists. \033[0m"
else
  echo "\033[0;33m    Add Host rust_dev_vscode_cnt to ~/.ssh/config \033[0m"
  echo 'Host rust_dev_vscode_cnt
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~\\.ssh\\rustdevuser_key
  IdentitiesOnly yes' | sudo tee -a ~/.ssh/config
fi

echo " "
echo "\033[0;33m    Install and setup finished. \033[0m"
echo "\033[0;33m    You can now create a pod with or without postgres: \033[0m"
echo "\033[0;33m sh rust_dev_pod_create.sh \033[0m"
echo "\033[0;33m    or \033[0m"
echo "\033[0;33m sh rust_pg_dev_pod_create.sh \033[0m"
echo "\033[0;33m    and later use the appropriate after_reboot script \033[0m"
echo "\033[0;33m sh rust_dev_pod_after_reboot.sh \033[0m"
echo "\033[0;33m    or \033[0m"
echo "\033[0;33m sh rust_pg_dev_pod_after_reboot.sh \033[0m"
echo "\033[0;33m    Check if the containers are started correctly \033[0m"
echo "\033[0;33m podman ps \033[0m"
echo "\033[0;33m    Every container must be started x seconds ago and not only created ! \033[0m"
echo "\033[0;33m    Follow the instructions from README.md to create the pod and connect to it over SSH. \033[0m"
