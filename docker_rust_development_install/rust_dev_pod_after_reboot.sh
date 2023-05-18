#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to correctly restart the pod 'sh rust_dev_pod_after_reboot.sh' \033[0m"

# repository: https://github.com/bestia-dev/docker_rust_development

# WSL2 have some quirks.
if grep -qi microsoft /proc/version; then    
    echo " "
    echo "\033[0;33m    You can simulate a reboot in Windows Powershell with: \033[0m"
    echo "\033[0;32m wsl --shutdown  \033[0m"
fi

# this will execute on Debian in WSL2 and on bare metal.
echo " "
echo "\033[0;33m    podman pod restart rust_dev_pod \033[0m"
podman pod restart rust_dev_pod
echo " "
echo "\033[0;33m    podman exec --user=root  rust_dev_vscode_cnt service ssh restart \033[0m"
podman exec --user=root  rust_dev_vscode_cnt service ssh restart
echo " "
echo "\033[0;33m    podman pod list \033[0m"
podman pod list
echo "\033[0;33m    podman ps -a \033[0m"
podman ps -a

echo " "
echo "\033[0;33m    Fast ssh connection test from terminal: \033[0m"
echo "\033[0;32m ssh -i ~/.ssh/rustdevuser_key -p 2201 rustdevuser@localhost \033[0m"
echo "\033[0;33m    Enter passphrase. \033[0m"
echo "\033[0;33m    The prompt should change to: rustdevuser@rust_dev_pod:~$ \033[0m"
echo "\033[0;32m cd ~/rustprojects \033[0m"
echo "\033[0;32m cargo new rust_dev_hello \033[0m"
echo "\033[0;32m cd rust_dev_hello \033[0m"
echo "\033[0;32m cargo run \033[0m"
echo "\033[0;32m exit \033[0m"

echo " "
echo "\033[0;33m    You can open VSCode directly on an existing project inside the container from the Linux host: \033[0m"
echo "\033[0;32m code --remote ssh-remote+rust_dev_vscode_cnt /home/rustdevuser/rustprojects \033[0m"
echo "\033[0;33m    It will ask for the ssh passphrase. \033[0m"
echo "\033[0;33m    If the command line does not return to bash, use Ctrl+<. I don't know why Ctrl+c does not work. \033[0m"

echo " "
echo "\033[0;33m    Squid limits connections to very few internet places. If you need to allow more, modify the \033[0m"
echo "\033[0;33m    etc_squid_squid.conf file then execute: \033[0m"
echo "\033[0;32m podman cp etc_squid_squid.conf rust_dev_squid_cnt:/etc/squid/squid.conf  \033[0m"
echo "\033[0;32m podman restart rust_dev_squid_cnt  \033[0m"

echo " "
echo "\033[0;33m    Be sure to push your code to GitHub frequently because sometimes containers just stop to work. \033[0m"
echo "\033[0;33m    You can delete the pod and ALL of the DATA it contains: \033[0m"
echo "\033[0;32m podman pod rm -f rust_dev_pod \033[0m"

echo " "
echo "\033[0;33m    To stop podman and shutdown Debian, use: \033[0m"
echo "\033[0;32m shut \033[0m"

echo " "
