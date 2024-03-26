#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to install Podman and setup for crustde_pod for development in Rust with VSCode. \033[0m"

# podman_install_and_setup.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

# if Debian inside WSL it needs some special care
if grep -qi microsoft /proc/version; then    
  if findmnt -o PROPAGATION / | grep -qi private ; then  
    echo "default propagation for / in WSL is private, for podman must be changed to shared"
    echo "sudo mount --make-rshared /"
    sudo mount --make-rshared /
    findmnt -o PROPAGATION /
  fi 
fi

echo " " 
if [ ! -f ~/.ssh/crustde_pod_keys/etc_ssh_sshd_config.conf ]; then
  echo "\033[0;33m    1. Copying etc_ssh_sshd_config.conf \033[0m"
  echo "mkdir -p ~/.ssh/crustde_pod_keys/etc/ssh"
  mkdir -p ~/.ssh/crustde_pod_keys/etc/ssh
  echo "cp etc_ssh_sshd_config.conf ~/.ssh/crustde_pod_keys/etc_ssh_sshd_config.conf"
  cp etc_ssh_sshd_config.conf ~/.ssh/crustde_pod_keys/etc_ssh_sshd_config.conf
else 
  echo "\033[0;33m    1. etc_ssh_sshd_config.conf already exists. \033[0m"
fi

echo " " 
if [ ! -f ~/.ssh/crustde_rustdevuser_ssh_1 ]; then
  echo "\033[0;33m    2. Generating crustde_rustdevuser_ssh_1 for the identity of 'rustdevuser'.  \033[0m"
  echo "\033[0;33m    This is done only once. To avoid old crypto-algorithms I will force the new 'ed25519'. \033[0m"
  echo "\033[0;33m    Give it a passphrase and remember it, you will need it. \033[0m"
  echo "ssh-keygen -f ~/.ssh/crustde_rustdevuser_ssh_1 -t ed25519 -C 'rustdevuser@crustde_pod'"
  ssh-keygen -f ~/.ssh/crustde_rustdevuser_ssh_1 -t ed25519 -C "rustdevuser@crustde_pod"
  chmod 600 ~/.ssh/crustde_rustdevuser_ssh_1
else 
  echo "\033[0;33m    2. SSH key crustde_rustdevuser_ssh_1 already exists. \033[0m"
fi

echo " " 
if [ ! -f ~/.ssh/crustde_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then
  echo "\033[0;33m    3. Generating ssh_host_ed25519_key for 'SSH server' identity of the container. \033[0m"
  echo "ssh-keygen -A -f ~/.ssh/crustde_pod_keys"
  ssh-keygen -A -f ~/.ssh/crustde_pod_keys  
else 
  echo "\033[0;33m    3. SSH key ssh_host_ed25519_key already exists. \033[0m"
fi

echo " " 
if ! [ -x "$(command -v podman)" ]; then
  echo "\033[0;33m    4. Installing Podman: \033[0m"
  echo "sudo apt-get install -y podman"
  sudo apt-get install -y podman
else
  echo "\033[0;33m    4. Podman is already installed. \033[0m"
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
  fi
  
  if grep -qi tmpfs /etc/fstab; then
    echo "fstab already contains tmpfs"
  else
    echo "\033[0;33m    WSL2 must have tmp in tmpfs, so it can restart correctly after reboot \033[0m"
    echo "echo 'none  /tmp  tmpfs  defaults  0 0' | sudo tee -a /etc/fstab"
    echo "none  /tmp  tmpfs  defaults  0 0" | sudo tee -a /etc/fstab
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
echo "\033[0;33m    8. Prepare the config file for VSCode SSH. \033[0m"
echo "\033[0;33m    If needed add manually to ~/.ssh/config in Windows \033[0m"
echo 'Host crustde_rustdevuser_ssh_1
   HostName localhost
   Port 2201
   User rustdevuser
   IdentityFile //wsl.localhost/Debian/home/luciano/.ssh/crustde_rustdevuser_ssh_1
'
echo "\033[0;33m    If needed add manually to ~/.ssh/config in Linux \033[0m"
echo 'Host crustde_rustdevuser_ssh_1
   HostName localhost
   Port 2201
   User rustdevuser
   IdentityFile ~/.ssh/crustde_rustdevuser_ssh_1
'

echo " "
echo "\033[0;33m    VSCode uses the file ~/.ssh/known_hosts to allow or disallow SSH connection to a server. Also to CRUSTDE container. \033[0m"
echo "\033[0;33m    If it finds some old fingerprint from the server it will just error on connection without telling the cause. \033[0m"
echo "\033[0;33m    Try renaming the file to known_hosts.bak and VSCode will just ask if the new fingerprint are correct and create a new known_hosts file. \033[0m"

echo " "
echo "\033[0;33m    Installing Podman and setup is finished. \033[0m"

echo ""
echo "\033[0;33m    Now you can create the pod crustde_pod. \033[0m"
echo "\033[0;33m    On first run it will download 1.06 GB from DockerHub, unpack to 3.32 GB and store it in the cache folder. \033[0m"
echo "\033[0;33m    After that, follow the detailed instructions. \033[0m"
echo "\033[0;32m cd ~/rustprojects/crustde_install/pod_with_rust_vscode \033[0m"
echo "\033[0;32m sh crustde_pod_create.sh \033[0m"

echo ""
echo "\033[0;33m    Check if the containers are started correctly \033[0m"
echo "\033[0;32m podman ps \033[0m"

echo ""
echo "\033[0;33m    You could remove the pod at any time. \033[0m"
echo "\033[0;33m    Attention: you will loose all your data inside the containers.  \033[0m"
echo "\033[0;33m    Be sure to commit and push to remote repository before removing the pod. \033[0m"
echo "\033[0;32m podman pod rm -f crustde_pod \033[0m"

echo " "
