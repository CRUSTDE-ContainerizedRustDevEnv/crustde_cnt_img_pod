#!/usr/bin/env bash

echo " "
echo "\033[0;33m    Bash script to install Podman and setup for rust_dev_pod for development in Rust with VSCode. \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development
echo " " 
echo "\033[0;33m    Prerequisites: Win10, WSL2, VSCode. \033[0m"
echo " " 
echo "\033[0;33m    0. Remove the 'testing repository' line in sources.list if it exists \033[0m"
echo "\033[0;33m    sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list \033[0m"
sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list
echo "\033[0;33m    sudo cat /etc/apt/sources.list \033[0m"
sudo cat /etc/apt/sources.list
echo "\033[0;33m    sudo apt update \033[0m"
sudo apt update
echo "\033[0;33m    Install openssh-client. \033[0m"
echo "\033[0;33m    sudo apt install -y openssh-client \033[0m"
sudo apt install -y openssh-client

echo " " 
echo "\033[0;33m    1. Create 2 SSH keys, one for the 'SSH server' identity 'host key' of the container and the other for the identity of 'rustdevuser'.  \033[0m"
echo "\033[0;33m    This is done only once. To avoid old crypto-algorithms I will force the new 'ed25519'. \033[0m"
echo "\033[0;33m    We will save these files to persist in the windows folder 'c:\Users\my_user_name\.ssh' \033[0m"
echo "\033[0;33m    You will copy them from there, if you destroy the container or WSL2. \033[0m"

echo "\033[0;33m    mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh \033[0m"
mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh

echo "\033[0;33m    setx.exe WSLENV 'USERPROFILE/p' \033[0m"
setx.exe WSLENV "USERPROFILE/p"

echo "\033[0;33m    First check in the Win10 folder 'c:\Users\my_user_name\.ssh' if there are some file already persistently stored. \033[0m"
if [ -f $USERPROFILE/.ssh/rustdevuser_key ]; then 
  echo "\033[0;33m  Copy rustdevuser_key from Windows persistent folder. \033[0m"
  cp -v $USERPROFILE/.ssh/rustdevuser_key ~/.ssh/rustdevuser_key
  cp -v $USERPROFILE/.ssh/rustdevuser_key.pub ~/.ssh/rustdevuser_key.pub
fi

if [ -f $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then 
  echo "\033[0;33m  Copy ssh_host_ed25519_key from Windows persistent folder. \033[0m"
  cp -v $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key
  cp -v $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key.pub ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key.pub
fi

echo "\033[0;33m    If keys do not exist then generate them. \033[0m"
if [ ! -f ~/.ssh/rustdevuser_key ]; then
  echo "\033[0;33m    generate user key \033[0m"
  echo "\033[0;33m    give it a passphrase and remember it, you will need it \033[0m"
  echo "\033[0;33m    ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C 'rustdevuser@rust_dev_pod' \033[0m"
  ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C "rustdevuser@rust_dev_pod \033[0m"
  echo "\033[0;33m  Copy files to persist in Windows folder. \033[0m"
  echo "\033[0;33m    cp -v ~/.ssh/rustdevuser_key $USERPROFILE/.ssh/rustdevuser_key \033[0m"
  cp -v ~/.ssh/rustdevuser_key $USERPROFILE/.ssh/rustdevuser_key
  echo "\033[0;33m    cp -v ~/.ssh/rustdevuser_key.pub $USERPROFILE/.ssh/rustdevuser_key.pub \033[0m"
  cp -v ~/.ssh/rustdevuser_key.pub $USERPROFILE/.ssh/rustdevuser_key.pub
  echo "\033[0;33m    ls -l $USERPROFILE/.ssh | grep 'rustdevuser' \033[0m"
  ls -l $USERPROFILE/.ssh | grep "rustdevuser"
else 
  echo "\033[0;33m    Key rustdevuser_key already exists. \033[0m"
fi

if [ ! -f ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then
  echo "\033[0;33m    generate host key \033[0m"
  echo "\033[0;33m    ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys \033[0m"
  ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys
  echo "\033[0;33m  Copy files to persist in Windows folder. \033[0m"
  echo "\033[0;33m    cp -v -r ~/.ssh/rust_dev_pod_keys $USERPROFILE/.ssh/rust_dev_pod_keys \033[0m"
  cp -v -r ~/.ssh/rust_dev_pod_keys $USERPROFILE/.ssh/rust_dev_pod_keys
  echo "\033[0;33m    ls -l $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh \033[0m"
  ls -l $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh
else 
  echo "\033[0;33m    Key ssh_host_ed25519_key already exists. \033[0m"
fi
# check
echo "\033[0;33m    ls -l ~/.ssh | grep 'rustdevuser' \033[0m"
ls -l ~/.ssh | grep "rustdevuser"
echo "\033[0;33m    ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh \033[0m"
ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh


echo " " 
echo "\033[0;33m    2. Install Podman in 'WSL2 terminal': \033[0m"
echo "\033[0;33m    sudo apt install -y podman \033[0m"
sudo apt install -y podman
echo "\033[0;33m    podman --version \033[0m"
podman --version
# podman 3.0.1

echo " " 
echo "\033[0;33m    3. The version 3.0.1 of Podman in the stable Debian 11 repository is old and buggy. It does not work well. We need a newer version. I will get the 'testing' version from Debian 12. This is a fairly stable version. 'Testing' is the last stage before 'stable' and it has successfully passed most of the tests.
Temporarily I will add the 'testing' repository to install this package. And after that remove it. \033[0m"
echo "\033[0;33m    sudo cat /etc/apt/sources.list \033[0m"
sudo cat /etc/apt/sources.list
if sudo grep -q "deb http://http.us.debian.org/debian/ testing non-free contrib main" "/etc/apt/sources.list"; then
  echo "\033[0;33m    line 'testing' in sources.list already exists? \033[0m"
else
  echo "\033[0;33m    echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' | sudo tee -a /etc/apt/sources.list \033[0m"
  echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' | sudo tee -a /etc/apt/sources.list
  echo "\033[0;33m    sudo cat /etc/apt/sources.list \033[0m"
  sudo cat /etc/apt/sources.list
  echo "\033[0;33m    sudo apt update \033[0m"
  sudo apt update
fi
# Then run 
echo "\033[0;33m    sudo apt install -y podman \033[0m"
sudo apt install -y podman
echo "\033[0;33m    podman info \033[0m"
podman info
# podman 3.4.4
echo "\033[0;33m    Now remove the temporary added line \033[0m"
echo "\033[0;33m    sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list \033[0m"
sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list
echo "\033[0;33m    sudo cat /etc/apt/sources.list \033[0m"
sudo cat /etc/apt/sources.list
echo "\033[0;33m    sudo apt update \033[0m"
sudo apt update

echo " "
echo "\033[0;33m    4. Podman needs a slight adjustment because it is inside WSL2. \033[0m"
if [ -f $HOME/.config/containers/containers.conf ]; then
  echo "\033[0;33m    $HOME/.config/containers/containers.conf already exists? \033[0m"
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
echo "\033[0;33m    5. Docker hub uses https with TLS/SSL encryption. The server certificate cannot be recognized by podman. We will add it to the local system simply by using curl once. \033[0m"
echo "\033[0;33m    sudo apt install -y curl \033[0m"
sudo apt install -y curl
echo "\033[0;33m    curl -s -v https://registry-1.docker.io/v2/ -o /dev/null \033[0m"
curl -s -v https://registry-1.docker.io/v2/ -o /dev/null
echo "\033[0;33m    That's it. The server certificate is now locally recognized. \033[0m"

echo " "
echo "\033[0;33m    6. Pull the docker images (around 2GB) in 'WSL2 terminal': \033[0m"
echo "\033[0;33m    podman pull docker.io/bestiadev/rust_dev_squid_img:latest \033[0m"
podman pull docker.io/bestiadev/rust_dev_squid_img:latest
echo "\033[0;33m    podman pull docker.io/bestiadev/rust_dev_vscode_img:latest \033[0m"
podman pull docker.io/bestiadev/rust_dev_vscode_img:latest

echo " "
echo "\033[0;33m    7. Download bash script and config files: \033[0m"
echo "\033[0;33m    mkdir -p ~/rustprojects/docker_rust_development \033[0m"
mkdir -p ~/rustprojects/docker_rust_development
echo "\033[0;33m    cd ~/rustprojects/docker_rust_development \033[0m"
cd ~/rustprojects/docker_rust_development
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf
echo "\033[0;33m    curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh \033[0m"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh
echo "\033[0;33m    check the downloaded files \033[0m"
echo "\033[0;33m    ls -l ~/rustprojects/docker_rust_development \033[0m"
ls -l ~/rustprojects/docker_rust_development
echo "\033[0;33m    cat etc_ssh_sshd_config.conf \033[0m"
cat etc_ssh_sshd_config.conf
echo "\033[0;33m    cat rust_dev_pod_create.sh \033[0m"
cat rust_dev_pod_create.sh
echo "\033[0;33m    cat rust_dev_pod_after_reboot.sh \033[0m"
cat rust_dev_pod_after_reboot.sh

echo " "
echo "\033[0;33m    8. Prepare the config file for VSCode SSH: \033[0m"
echo "\033[0;33m    Check if the word rust_dev_pod already exists in the config file. \033[0m"
if grep -q "Host rust_dev_pod" "$USERPROFILE/.ssh/config"; then
  echo "\033[0;33m    VSCode config for SSH already exists. \033[0m"
else
  echo "\033[0;33m    Add Host rust_dev_pod to $USERPROFILE/.ssh/config \033[0m"
  echo 'Host rust_dev_pod
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~\\.ssh\\rustdevuser_key
  IdentitiesOnly yes' | sudo tee -a $USERPROFILE/.ssh/config
fi

sh rust_dev_pod_create.sh

echo " "
echo "\033[0;33m    Install and setup finished. \033[0m"
echo "\033[0;33m    Follow the instructions from README.md to create the pod and connect to it over SSH. \033[0m"
