#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to install Podman and setup for rust_dev_pod for development in Rust with VSCode. \033[0m"

# podman_install_and_setup.sh
# repository: https://github.com/bestia-dev/docker_rust_development

# if Debian inside WSL it needs some special care
if grep -qi microsoft /proc/version; then    
  # here I need the Windows profile folder
  echo "setx.exe WSLENV 'USERPROFILE/p'"
  setx.exe WSLENV "USERPROFILE/p"
fi

echo " " 
if [ ! -f ~/.ssh/rust_dev_pod_keys/etc_ssh_sshd_config.conf ]; then
  echo "\033[0;33m    1. Copying etc_ssh_sshd_config.conf \033[0m"
  echo "mkdir -p ~/.ssh/rust_dev_pod_keys/etc/ssh"
  mkdir -p ~/.ssh/rust_dev_pod_keys/etc/ssh
  echo "cp etc_ssh_sshd_config.conf ~/.ssh/rust_dev_pod_keys/etc_ssh_sshd_config.conf"
  cp etc_ssh_sshd_config.conf ~/.ssh/rust_dev_pod_keys/etc_ssh_sshd_config.conf
else 
  echo "\033[0;33m    1. etc_ssh_sshd_config.conf already exists. \033[0m"
fi

echo " " 
if [ ! -f ~/.ssh/rustdevuser_key ]; then
  echo "\033[0;33m    2. Generating rustdevuser_key for the identity of 'rustdevuser'.  \033[0m"
  echo "\033[0;33m    This is done only once. To avoid old crypto-algorithms I will force the new 'ed25519'. \033[0m"
  echo "\033[0;33m    Give it a passphrase and remember it, you will need it. \033[0m"
  echo "ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C 'rustdevuser@rust_dev_pod'"
  ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C "rustdevuser@rust_dev_pod"
  chmod 600 ~/.ssh/rustdevuser_key
  # if WSL, copy rustdevuser_key to windows
  if grep -qi microsoft /proc/version; then    
    cp -v ~/.ssh/rustdevuser_key $USERPROFILE/.ssh/
    cp -v ~/.ssh/rustdevuser_key.pub $USERPROFILE/.ssh/
  fi

else 
  echo "\033[0;33m    2. SSH key rustdevuser_key already exists. \033[0m"
fi

echo " " 
if [ ! -f ~/.ssh/rustdevuser_rsa_key ]; then
  echo "\033[0;33m    3. Generating rustdevuser_rsa_key for the identity of 'rustdevuser'  \033[0m"
  echo "\033[0;33m    because dbl_commander cannot use the ed25519 key. \033[0m"
  echo "\033[0;33m    Give it the same passphrase and remember it, you will need it. \033[0m"
  echo "ssh-keygen -t rsa -b 4096 -m PEM -C rustdevuser@rust_dev_pod -f ~/.ssh/rustdevuser_rsa_key"
  ssh-keygen -t rsa -b 4096 -m PEM -C rustdevuser@rust_dev_pod -f ~/.ssh/rustdevuser_rsa_key
  chmod 600 $HOME/.ssh/rustdevuser_rsa_key
else 
  echo "\033[0;33m    3. SSH key rustdevuser_rsa_key already exists. \033[0m"
fi

echo " " 
if [ ! -f ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then
  echo "\033[0;33m    4. Generating ssh_host_ed25519_key for 'SSH server' identity of the container. \033[0m"
  echo "ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys"
  ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys  
else 
  echo "\033[0;33m    4. SSH key ssh_host_ed25519_key already exists. \033[0m"
fi

echo " " 
if ! [ -x "$(command -v podman)" ]; then
  echo "\033[0;33m    5. Installing Podman: \033[0m"
  echo "sudo apt install -y podman"
  sudo apt install -y podman
else
  echo "\033[0;33m    5. Podman is already installed. \033[0m"
fi

echo " " 
echo "podman --version "
podman --version
# podman 3.0.1

# this step only for WSL:
echo " "
if grep -qi microsoft /proc/version; then  
  echo "\033[0;33m    6. Podman needs a slight adjustment because it is inside WSL2. \033[0m"
  if [ -f $HOME/.config/containers/containers.conf ]; then
    echo "\033[0;33m    $HOME/.config/containers/containers.conf already exists. \033[0m"
  else
    echo "mkdir -p $HOME/.config/containers"
    mkdir -p $HOME/.config/containers
    echo '  [engine]
    cgroup_manager = "cgroupfs"
    events_logger = "file"'
    echo " | tee -a $HOME/.config/containers/containers.conf"
    echo '[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"' | tee -a $HOME/.config/containers/containers.conf
    
    echo "\033[0;33m    WSL2 must have tmp in tmpfs, so it can restart correctly after reboot \033[0m"
    echo "sudo grep -qxF 'none  /tmp  tmpfs  defaults  0 0' /etc/fstab || echo 'none  /tmp  tmpfs  defaults  0 0' | sudo tee -a /etc/fstab"
    sudo grep -qxF 'none  /tmp  tmpfs  defaults  0 0' /etc/fstab || echo "none  /tmp  tmpfs  defaults  0 0" | sudo tee -a /etc/fstab

  fi
  else
    echo "\033[0;33m    6. Podman is NOT inside WSL2. \033[0m"
fi

echo " "
echo "\033[0;33m    7. Docker hub uses https with TLS/SSL encryption. \033[0m"
echo "\033[0;33m    The server certificate cannot be recognized by podman.  \033[0m"
echo "\033[0;33m    We will add it to the local system simply by using curl once. \033[0m"
echo "curl -s https://registry-1.docker.io/v2/ > /dev/null"
curl -s  https://registry-1.docker.io/v2/ > /dev/null
echo "\033[0;33m    That's it. The server certificate is now locally recognized. \033[0m"

echo " "
echo "\033[0;33m    8. Prepare the config file for VSCode SSH: \033[0m"
echo "\033[0;33m    Check if the word rust_dev_vscode_cnt already exists in the config file. \033[0m"

# create file if it does not exist
if [ ! -f ~/.ssh/config ]; then
      echo '' | tee -a ~/.ssh/config
fi

if grep -qi "Host rust_dev_vscode_cnt" "$HOME/.ssh/config"; then
  echo "\033[0;33m    VSCode config for SSH already exists. \033[0m"
else
  echo "\033[0;33m    Add Host rust_dev_vscode_cnt to ~/.ssh/config \033[0m"
  
  if grep -qi microsoft /proc/version; then  
    # in VSCode Windows they use backslash    
    echo 'Host rust_dev_vscode_cnt
HostName localhost
Port 2201
User rustdevuser
IdentityFile ~\\.ssh\\rustdevuser_key
IdentitiesOnly yes' | tee -a ~/.ssh/config
echo "| tee -a ~/.ssh/config"
cp -v ~/.ssh/config $USERPROFILE/.ssh/
  else
    # in VSCode Debian they use slash
    echo 'Host rust_dev_vscode_cnt
HostName localhost
Port 2201
User rustdevuser
IdentityFile ~/.ssh/rustdevuser_key
IdentitiesOnly yes' | tee -a ~/.ssh/config
    echo "| tee -a ~/.ssh/config"
  fi

fi

echo " "
echo "\033[0;33m    Install podman and setup finished. \033[0m"

echo ""
echo "\033[0;33m    Now you can create the pod rust_dev_pod. \033[0m"
echo "\033[0;33m    On first run it will download around 1.2 GB from DockerHub and store it in the cache for later use. \033[0m"
echo "\033[0;33m    After that, follow the detailed instructions. \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust_vscode/rust_dev_pod_create.sh \033[0m"

echo ""
echo "\033[0;33m    Check if the containers are started correctly \033[0m"
echo "\033[0;32m podman ps \033[0m"

echo ""
echo "\033[0;33m    You could remove the pod at any time. \033[0m"
echo "\033[0;33m    Attention: you will loose all your data inside the containers.  \033[0m"
echo "\033[0;33m    Be sure to commit and push to remote repository before removing the pod. \033[0m"
echo "\033[0;32m podman pod rm -f rust_dev_pod \033[0m"

echo " "
