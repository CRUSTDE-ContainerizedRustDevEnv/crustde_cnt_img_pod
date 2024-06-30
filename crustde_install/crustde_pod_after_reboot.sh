#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to correctly restart the pod 'sh crustde_pod_after_reboot.sh' \033[0m\n"

# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

# WSL2 have some quirks.
if grep -qi microsoft /proc/version; then    
    printf " \n"
    printf "\033[0;33m    You can simulate a WSL Debian reboot in Windows Powershell with: \033[0m\n"
    printf "\033[0;32m wsl --shutdown  \033[0m\n"

  if findmnt -o PROPAGATION / | grep -qi private ; then  
    printf "default propagation for / in WSL is private, for podman must be changed to shared\n"
    printf "sudo mount --make-rshared /\n"
    sudo mount --make-rshared /
    findmnt -o PROPAGATION /
  fi 
fi

# this will execute on Debian in WSL2 and on bare metal.
printf " \n"
printf "\033[0;33m    podman pod restart crustde_pod \033[0m\n"
podman pod restart crustde_pod
printf " \n"
printf "\033[0;33m    podman exec --user=root  crustde_vscode_cnt service ssh restart \033[0m\n"
podman exec --user=root  crustde_vscode_cnt service ssh restart
printf " \n"
printf "\033[0;33m    podman pod list \033[0m\n"
podman pod list
printf "\033[0;33m    podman ps -a \033[0m\n"
podman ps -a

printf " \n"
printf "\033[0;33m    Fast ssh connection test from terminal: \033[0m\n"
printf "\033[0;32m ssh -i ~/.ssh/crustde_rustdevuser_ssh_1 -p 2201 rustdevuser@localhost \033[0m\n"
printf "\033[0;33m    Enter passphrase. \033[0m\n"
printf "\033[0;33m    The prompt should change to: rustdevuser@crustde_pod:~$ \033[0m\n"
printf "\033[0;32m exit \033[0m\n"

printf " \n"
printf "\033[0;33m    You can connect VSCode to an existing project inside the container from the host bash or Windows git-bash: \033[0m\n"
printf "\033[0;33m    Use the global command 'sshadd' to simply add your private SSH keys to ssh-agent \033[0m\n"
printf "\033[0;32m sshadd \033[0m\n"
printf "\033[0;32m MSYS_NO_PATHCONV=1 code --remote ssh-remote+crustde_rustdevuser /home/rustdevuser/rustprojects \033[0m\n"
printf "\033[0;33m    In 'Windows git-bash', the MSYS_NO_PATHCONV is used to disable the default path conversion. \033[0m\n"

printf " \n"
printf "\033[0;33m    If VSCode cannot connect to the container, it is 99%% blame on the ~/.ssh/known_hosts file. \033[0m\n"
printf "\033[0;33m    There is an old fingerprint of the server. Rename the file to known_hosts.bak and retry. \033[0m\n"

printf " \n"
printf "\033[0;33m    Squid restricts connections to very few whitelisted internet places.  \033[0m\n"
printf "\033[0;33m    If you need to allow more, modify the etc_squid_squid.conf file then execute: \033[0m\n"
printf "\033[0;32m sh copy_squid_config_and_restart_cnt.sh  \033[0m\n"

printf " \n"
printf "\033[0;33m    Be sure to push your code to GitHub frequently because sometimes containers just stop working. \033[0m\n"
printf "\033[0;33m    You can delete the pod and ALL of the DATA it contains: \033[0m\n"
printf "\033[0;32m podman pod rm -f crustde_pod \033[0m\n"

printf " \n"
printf "\033[0;33m    To stop podman before shutdown, use: \033[0m\n"
printf "\033[0;32m podman pod stop -a \033[0m\n"

printf " \n"
