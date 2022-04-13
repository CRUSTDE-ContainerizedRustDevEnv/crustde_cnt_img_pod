#!/usr/bin/env bash

echo " "
echo "  Bash script to install Podman and setup for rust_dev_pod for development in Rust with VSCode."
echo "  repository: https://github.com/bestia-dev/docker_rust_development"
echo " " 
echo "  Prerequisites: Win10, WSL2, VSCode."
echo " " 
echo "  0. Remove the 'testing repository' line in sources.list if it exists"
echo "  sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list"
sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list
echo "  sudo cat /etc/apt/sources.list"
sudo cat /etc/apt/sources.list
echo "  sudo apt update"
sudo apt update
echo "  Install openssh-client."
echo "  sudo apt install -y openssh-client"
sudo apt install -y openssh-client

echo " " 
echo "  1. Create 2 SSH keys, one for the 'SSH server' identity 'host key' of the container and the other for the identity of 'rustdevuser'. "
echo "  This is done only once. To avoid old crypto-algorithms I will force the new 'ed25519'."
echo "  We will save these files to persist in the windows folder 'c:\Users\my_user_name\.ssh'"
echo "  You will copy them from there, if you destroy the container or WSL2."

echo "  mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh"
mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh

echo "  setx.exe WSLENV 'USERPROFILE/p'"
setx.exe WSLENV "USERPROFILE/p"

echo "  First check in the Win10 folder 'c:\Users\my_user_name\.ssh' if there are some file already persistently stored."
if [ -f $USERPROFILE/.ssh/rustdevuser_key ]; then 
  echo " Copy rustdevuser_key from Windows persistent folder."
  cp -v $USERPROFILE/.ssh/rustdevuser_key ~/.ssh/rustdevuser_key
  cp -v $USERPROFILE/.ssh/rustdevuser_key.pub ~/.ssh/rustdevuser_key.pub
fi

if [ -f $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then 
  echo " Copy ssh_host_ed25519_key from Windows persistent folder."
  cp -v $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key
  cp -v $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key.pub ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key.pub
fi

echo "  If keys do not exist then generate them."
if [ ! -f ~/.ssh/rustdevuser_key ]; then
  echo "  generate user key"
  echo "  give it a passphrase and remember it, you will need it"
  echo "  ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C 'info@bestia.dev'"
  ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C "info@bestia.dev"
  echo " Copy files to persist in Windows folder."
  echo "  cp -v ~/.ssh/rustdevuser_key $USERPROFILE/.ssh/rustdevuser_key"
  cp -v ~/.ssh/rustdevuser_key $USERPROFILE/.ssh/rustdevuser_key
  echo "  cp -v ~/.ssh/rustdevuser_key.pub $USERPROFILE/.ssh/rustdevuser_key.pub"
  cp -v ~/.ssh/rustdevuser_key.pub $USERPROFILE/.ssh/rustdevuser_key.pub
  echo "  ls -l $USERPROFILE/.ssh | grep 'rustdevuser'"
  ls -l $USERPROFILE/.ssh | grep "rustdevuser"
else 
  echo "  Key rustdevuser_key already exists."
fi

if [ ! -f ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then
  echo "  generate host key"
  echo "  ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys"
  ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys
  echo " Copy files to persist in Windows folder."
  echo "  cp -v -r ~/.ssh/rust_dev_pod_keys $USERPROFILE/.ssh/rust_dev_pod_keys"
  cp -v -r ~/.ssh/rust_dev_pod_keys $USERPROFILE/.ssh/rust_dev_pod_keys
  echo "  ls -l $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh"
  ls -l $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh
else 
  echo "  Key ssh_host_ed25519_key already exists."
fi
# check
echo "  ls -l ~/.ssh | grep 'rustdevuser'"
ls -l ~/.ssh | grep "rustdevuser"
echo "  ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh"
ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh


echo " " 
echo "  2. Install Podman in 'WSL2 terminal':"
echo "  sudo apt install -y podman"
sudo apt install -y podman
echo "  podman --version"
podman --version
# podman 3.0.1

echo " " 
echo "  3. The version 3.0.1 of Podman in the stable Debian 11 repository is old and buggy. It does not work well. We need a newer version. I will get the 'testing' version from Debian 12. This is a fairly stable version. 'Testing' is the last stage before 'stable' and it has successfully passed most of the tests.
Temporarily I will add the 'testing' repository to install this package. And after that remove it."
echo "  sudo cat /etc/apt/sources.list"
sudo cat /etc/apt/sources.list
if sudo grep -q "deb http://http.us.debian.org/debian/ testing non-free contrib main" "/etc/apt/sources.list"; then
  echo "  line 'testing' in sources.list already exists?"
else
  echo "  echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' | sudo tee -a /etc/apt/sources.list"
  echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' | sudo tee -a /etc/apt/sources.list
  echo "  sudo cat /etc/apt/sources.list"
  sudo cat /etc/apt/sources.list
  echo "  sudo apt update"
  sudo apt update
fi
# Then run 
echo "  sudo apt install -y podman"
sudo apt install -y podman
echo "  podman info"
podman info
# podman 3.4.4
echo "  Now remove the temporary added line"
echo "  sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list"
sudo sed -i.bak '/deb http:\/\/http.us.debian.org\/debian\/ testing non-free contrib main/d' /etc/apt/sources.list
echo "  sudo cat /etc/apt/sources.list"
sudo cat /etc/apt/sources.list
echo "  sudo apt update"
sudo apt update

echo " "
echo "  4. Podman needs a slight adjustment because it is inside WSL2."
if [ -f $HOME/.config/containers/containers.conf ]; then
  echo "  $HOME/.config/containers/containers.conf already exists?"
else
    echo "  mkdir $HOME/.config/containers"
mkdir $HOME/.config/containers
  echo '  [engine]
  cgroup_manager = "cgroupfs"
  events_logger = "file"'
  echo "  | sudo tee -a $HOME/.config/containers/containers.conf"
  echo '[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"' | sudo tee -a $HOME/.config/containers/containers.conf
fi

echo " "
echo "  5. Docker hub uses https with TLS/SSL encryption. The server certificate cannot be recognized by podman. We will add it to the local system simply by using curl once."
echo "  sudo apt install -y curl"
sudo apt install -y curl
echo "  curl -s -v https://registry-1.docker.io/v2/ -o /dev/null"
curl -s -v https://registry-1.docker.io/v2/ -o /dev/null
echo "  That's it. The server certificate is now locally recognized."

echo " "
echo "  6. Pull the docker images (around 2GB) in 'WSL2 terminal':"
echo "  podman pull docker.io/bestiadev/rust_dev_squid_img:latest"
podman pull docker.io/bestiadev/rust_dev_squid_img:latest
echo "  podman pull docker.io/bestiadev/rust_dev_vscode_img:latest"
podman pull docker.io/bestiadev/rust_dev_vscode_img:latest

echo " "
echo "  7. Download bash script and config files:"
echo "  mkdir -p ~/rustprojects/docker_rust_development"
mkdir -p ~/rustprojects/docker_rust_development
echo "  cd ~/rustprojects/docker_rust_development"
cd ~/rustprojects/docker_rust_development
echo "  curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_create.sh --output rust_dev_pod_create.sh
echo "  curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/etc_ssh_sshd_config.conf --output etc_ssh_sshd_config.conf
echo "  curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh"
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/rust_dev_pod_after_reboot.sh --output rust_dev_pod_after_reboot.sh
echo "  check the downloaded files"
echo "  ls -l ~/rustprojects/docker_rust_development"
ls -l ~/rustprojects/docker_rust_development
echo "  cat etc_ssh_sshd_config.conf"
cat etc_ssh_sshd_config.conf
echo "  cat rust_dev_pod_create.sh"
cat rust_dev_pod_create.sh
echo "  cat rust_dev_pod_after_reboot.sh"
cat rust_dev_pod_after_reboot.sh

echo " "
echo "  8. Prepare the config file for VSCode SSH:"
echo "  Check if the word rust_dev_pod already exists in the config file."
if grep -q "Host rust_dev_pod" "$USERPROFILE/.ssh/config"; then
  echo "  VSCode config for SSH already exists."
else
  echo "  Add Host rust_dev_pod to $USERPROFILE/.ssh/config"
  echo 'Host rust_dev_pod
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~\\.ssh\\rustdevuser_key
  IdentitiesOnly yes' | sudo tee -a $USERPROFILE/.ssh/config
fi

echo " "
echo "  Install and setup finished."
echo "  Follow the instructions from README.md to create the pod and connect to it over SSH."
