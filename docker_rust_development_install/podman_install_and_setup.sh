#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to install Podman and setup for rust_dev_pod for development in Rust with VSCode. \033[0m"

# podman_install_and_setup.sh
# repository: https://github.com/bestia-dev/docker_rust_development

echo " " 
echo "\033[0;33m    Prerequisites: Debian, VSCode, downloaded scripts, your personal data already in ~/.ssh \033[0m"

echo " " 
echo "\033[0;33m    1. Create 2 SSH keys, one for the 'SSH server' identity 'host key' of the container and the other for the identity of 'rustdevuser'.  \033[0m"
echo "\033[0;33m    This is done only once. To avoid old crypto-algorithms I will force the new 'ed25519'. \033[0m"

echo "\033[0;33m    mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh \033[0m"
mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh

cp etc_ssh_sshd_config.conf ~/.ssh/rust_dev_pod_keys/etc_ssh_sshd_config.conf

echo "\033[0;33m    If keys do not exist then generate them. \033[0m"
if [ ! -f ~/.ssh/rustdevuser_key ]; then
  echo "\033[0;33m    generate user key \033[0m"
  echo "\033[0;33m    give it a passphrase and remember it, you will need it \033[0m"
  echo "\033[0;33m    ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C 'rustdevuser@rust_dev_pod' \033[0m"
  ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C "rustdevuser@rust_dev_pod"
else 
  echo "\033[0;33m    Key rustdevuser_key already exists. \033[0m"
fi
chmod 600 ~/.ssh/rustdevuser_key

if [ ! -f ~/.ssh/rustdevuser_rsa_key ]; then
  echo "\033[0;33m    generate user rsa key for dbl commander \033[0m"
  echo "\033[0;33m    give it a passphrase and remember it, you will need it \033[0m"
  echo "\033[0;33m    ssh-keygen -t rsa -b 4096 -m PEM -C rustdevuser@rust_dev_pod -f ~/.ssh/rustdevuser_rsa_key \033[0m"
  ssh-keygen -t rsa -b 4096 -m PEM -C rustdevuser@rust_dev_pod -f ~/.ssh/rustdevuser_rsa_key
else 
  echo "\033[0;33m    Key rustdevuser_rsa_key already exists. \033[0m"
fi
chmod 600 /home/rustdevuser/.ssh/rustdevuser_rsa_key

if [ ! -f ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key ]; then
  echo "\033[0;33m    generate host key \033[0m"
  echo "\033[0;33m    ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys \033[0m"
  ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys
else 
  echo "\033[0;33m    Key ssh_host_ed25519_key already exists. \033[0m"
fi

echo " " 
echo "\033[0;33m    2. Install Podman: \033[0m"
if ! [ -x "$(command -v podman)" ]; then
  echo "\033[0;33m    sudo apt install -y podman \033[0m"
  sudo apt install -y podman
else
  echo "\033[0;33m    Podman already installed. \033[0m"
fi

echo "\033[0;33m    podman --version \033[0m"
podman --version
# podman 3.0.1

# this step only for WSL:
if grep -qi microsoft /proc/version; then
  echo " "
  echo "\033[0;33m    3. Podman needs a slight adjustment because it is inside WSL2. \033[0m"
  if [ -f $HOME/.config/containers/containers.conf ]; then
    echo "\033[0;33m    $HOME/.config/containers/containers.conf already exists. \033[0m"
  else
    echo "\033[0;33m    mkdir -p $HOME/.config/containers \033[0m"
    mkdir -p $HOME/.config/containers
    echo '  [engine]
    cgroup_manager = "cgroupfs"
    events_logger = "file"'
    echo "\033[0;33m    | tee -a $HOME/.config/containers/containers.conf \033[0m"
    echo '[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"' | tee -a $HOME/.config/containers/containers.conf
  fi
fi

echo " "
echo "\033[0;33m    4. Docker hub uses https with TLS/SSL encryption. The server certificate cannot be recognized by podman. We will add it to the local system simply by using curl once. \033[0m"
echo "\033[0;33m    curl -s -v https://registry-1.docker.io/v2/ > /dev/null \033[0m"
curl -s  https://registry-1.docker.io/v2/ > /dev/null
echo "\033[0;33m    That's it. The server certificate is now locally recognized. \033[0m"

echo " "
echo "\033[0;33m    5. Prepare the config file for VSCode SSH: \033[0m"
echo "\033[0;33m    Check if the word rust_dev_vscode_cnt already exists in the config file. \033[0m"
if grep -q "Host rust_dev_vscode_cnt" "$HOME/.ssh/config"; then
  echo "\033[0;33m    VSCode config for SSH already exists. \033[0m"
else
  echo "\033[0;33m    Add Host rust_dev_vscode_cnt to ~/.ssh/config \033[0m"
  
  if grep -qi microsoft /proc/version; then  
    # in VSCode Windows they use backslash
    # here I need the windows profile folder
    setx.exe WSLENV "USERPROFILE/p"
# TODO: is this working for WSL?
    echo 'Host rust_dev_vscode_cnt
HostName localhost
Port 2201
User rustdevuser
IdentityFile $USERPROFILE\\.ssh\\rustdevuser_key
IdentitiesOnly yes' | tee -a ~/.ssh/config
  else
    # in VSCode Debian they use slash
    echo 'Host rust_dev_vscode_cnt
HostName localhost
Port 2201
User rustdevuser
IdentityFile ~/.ssh/rustdevuser_key
IdentitiesOnly yes' | tee -a ~/.ssh/config
  fi

fi

echo " "
echo "\033[0;33m    Install and setup finished. \033[0m"

echo ""
echo "\033[0;33m    Now you can create your pod. \033[0m"
echo "\033[0;33m    You can choose between 3 pods. You cannot use them simultaneously. You have to choose only one. \033[0m"
echo "\033[0;33m    If the pod already exists remove it. \033[0m"
echo "\033[0;33m    Attention: you will loose all your data inside the containers. Be sure to have already copied or pushed all out of the container. \033[0m"
echo "\033[0;32m podman pod rm -f rust_dev_pod \033[0m"
echo "\033[0;33m    1. pod with rust and vscode: \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust_vscode/rust_dev_pod_create.sh \033[0m"
echo "\033[0;33m    2. pod with rust, postgres and vscode: \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust_pg_vscode/rust_dev_pod_create.sh \033[0m"
echo "\033[0;33m    3. pod with rust, typescript and vscode: \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust_ts_vscode/rust_dev_pod_create.sh \033[0m"
echo ""
echo "\033[0;33m    Check if the containers are started correctly \033[0m"
echo "\033[0;32m podman ps \033[0m"
echo "\033[0;33m    Every container must be started x seconds ago and not only created ! \033[0m"

echo " "
