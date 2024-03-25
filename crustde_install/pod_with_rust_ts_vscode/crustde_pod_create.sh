#!/bin/sh

# README:

echo " "
echo "\033[0;33m    Bash script to create the pod 'crustde_pod': 'sh crustde_pod_create.sh' \033[0m"
echo "\033[0;33m    This 'pod' is made of 2 containers: 'crustde_squid_cnt' and 'rust_ts_dev_vscode_cnt' \033[0m"
echo "\033[0;33m    It contains Rust, cargo, rustc, VSCode and typescript development environment' \033[0m"
echo "\033[0;33m    All outbound network traffic from crustde_vscode_cnt goes through the proxy Squid. \033[0m"
echo "\033[0;33m    Published inbound network ports are 8001 on 'localhost' \033[0m"
# repository: https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/crustde_cnt_img_pod

echo " "
echo "\033[0;33m    Create pod \033[0m"
# in a "pod" the "publish port" is tied to the pod and not containers.
# http connection     8001
# ssh connection      2201

podman pod create \
-p 127.0.0.1:8001:8001/tcp \
-p 127.0.0.1:2201:2201/tcp \
--label name=crustde_pod \
--label version=1.0 \
--label source=github.com/CRUSTDE-Containerized-Rust-Dev-Env/crustde_cnt_img_pod \
--label author=github.com/bestia-dev \
--name crustde_pod

echo " "
echo "\033[0;33m    Create container crustde_squid_cnt in the pod \033[0m"
podman create --name crustde_squid_cnt \
--pod=crustde_pod -ti \
docker.io/bestiadev/crustde_squid_img:latest

echo " "
echo "\033[0;33m    Copy squid.conf for customized ACL proxy permissions \033[0m"
podman cp etc_squid_squid.conf crustde_squid_cnt:/etc/squid/squid.conf

echo " "
echo "\033[0;33m    Create container crustde_vscode_cnt in the pod \033[0m"
podman create --name crustde_vscode_cnt --pod=crustde_pod -ti \
docker.io/bestiadev/rust_ts_dev_vscode_img:latest

echo "\033[0;33m    Copy SSH server config \033[0m"
podman cp ~/.ssh/crustde_pod_keys/etc_ssh_sshd_config.conf crustde_vscode_cnt:/etc/ssh/sshd_config
echo "\033[0;33m    Copy the files for host keys ed25519 for SSH server in crustde_pod \033[0m"
podman cp ~/.ssh/crustde_pod_keys/etc/ssh/ssh_host_ed25519_key  crustde_vscode_cnt:/etc/ssh/ssh_host_ed25519_key
podman cp ~/.ssh/crustde_pod_keys/etc/ssh/ssh_host_ed25519_key.pub  crustde_vscode_cnt:/etc/ssh/ssh_host_ed25519_key.pub
echo "\033[0;33m    Copy the public key of rustdevuser \033[0m"
podman cp ~/.ssh/localhost_2201_rustdevuser_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/localhost_2201_rustdevuser_ssh_1.pub

echo "\033[0;33m    podman pod start \033[0m"
podman pod start crustde_pod

echo "\033[0;33m    Add env var for proxy settings \033[0m"
# echo a newline to avoid appending to the last line.
podman exec --user=rustdevuser  crustde_vscode_cnt /bin/sh -c 'echo "" >>  ~/.bashrc'
podman exec --user=rustdevuser  crustde_vscode_cnt /bin/sh -c 'echo "export http_proxy=\"http://localhost:3128\"" >>  ~/.bashrc'
podman exec --user=rustdevuser  crustde_vscode_cnt /bin/sh -c 'echo "export https_proxy=\"http://localhost:3128\"" >>  ~/.bashrc'
podman exec --user=rustdevuser  crustde_vscode_cnt /bin/sh -c 'echo "export all_proxy=\"http://localhost:3128\"" >>  ~/.bashrc'
podman exec --user=rustdevuser  crustde_vscode_cnt /bin/sh -c '. ~/.bashrc'

echo "\033[0;33m    User permissions: \033[0m"
# check the copied files
# TODO: this commands return a WARN[0000] Error resizing exec session 
# that looks like a bug in podman
# podman exec --user=rustdevuser crustde_vscode_cnt cat /etc/ssh/sshd_config
# podman exec --user=rustdevuser crustde_vscode_cnt cat /etc/ssh/ssh_host_ed25519_key
podman exec --user=rustdevuser crustde_vscode_cnt cat /etc/ssh/ssh_host_ed25519_key.pub
# always is the problem in permissions
# Chmod 700 (chmod a+rwx,g-rwx,o-rwx) sets permissions so that, 
# (U)ser / owner can read, can write and can execute. 
# (G)roup can't read, can't write and can't execute. 
# (O)thers can't read, can't write and can't execute.
podman exec --user=rustdevuser crustde_vscode_cnt chmod 700 /home/rustdevuser/.ssh

echo "\033[0;33m    add localhost_2201_rustdevuser_ssh_1 to authorized_keys \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt touch /home/rustdevuser/.ssh/authorized_keys
# Chmod 600 (chmod a+rwx,u-x,g-rwx,o-rwx) sets permissions so that, 
# (U)ser / owner can read, can write and can't execute. 
# (G)roup can't read, can't write and can't execute. 
# (O)thers can't read, can't write and can't execute.
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/authorized_keys
podman exec --user=rustdevuser crustde_vscode_cnt /bin/sh -c 'cat /home/rustdevuser/.ssh/localhost_2201_rustdevuser_ssh_1.pub >> /home/rustdevuser/.ssh/authorized_keys'

# echo "\033[0;33m    I have to disable the password for rustdevuser to enable SSH access with public key? Why? \033[0m"
podman exec --user=root crustde_vscode_cnt usermod --password '*' rustdevuser

echo "\033[0;33m    Git global config \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global pull.rebase false

echo "\033[0;33m    Remove the known_hosts for this pod/container in Linux. \033[0m"
echo "\033[0;33m    Remove the offending lines in Windows known_hosts manually. \033[0m"
ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:2201";

echo "\033[0;33m    Copy the personal files, SSH keys for github or publish-to-web,... \033[0m"
sh ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh

# echo "\033[0;33m    Fill the ~/.ssh/known_hosts with public fingerprints from github.com \033[0m"
# podman exec --user=rustdevuser crustde_vscode_cnt /bin/sh -c 'ssh-keyscan -H github.com >> ~/.ssh/known_hosts'

echo " "
echo "\033[0;33m    To start this 'pod' it is mandatory to run this bash script (after every reboot just once):  \033[0m"
echo "\033[0;32m sh ~/rustprojects/crustde_install/crustde_pod_after_reboot.sh \033[0m"
echo "\033[0;33m    If you have already run it, you can find it in the bash history:  \033[0m"
echo "\033[0;32m Ctrl-R, type after, press Esc, press Enter  \033[0m"

# this step only for WSL:
if grep -qi microsoft /proc/version; then
    echo "\033[0;33m    You can force the WSL reboot in Powershell:  \033[0m"
    echo "\033[0;32m  wsl --shutdown  \033[0m"
fi

echo " "
echo "\033[0;33m    Be sure to push your code to GitHub frequently because sometimes containers just stop to work. \033[0m"
echo "\033[0;33m    You can delete the pod and ALL of the DATA it contains: \033[0m"
echo "\033[0;32m podman pod rm -f crustde_pod \033[0m"

echo " "
