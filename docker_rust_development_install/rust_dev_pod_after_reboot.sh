#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to restart the pod 'sh rust_dev_pod_after_reboot.sh' \033[0m"

# repository: https://github.com/bestia-dev/docker_rust_development

# WSL2 have some quirks.
if grep -qi microsoft /proc/version; then
    echo " "
    echo "\033[0;33m    Warning: Use this only once after Debian reboot! \033[0m"
    echo "\033[0;33m    You can simulate a reboot in windows powershell with: \033[0m"
    echo "\033[0;33m Get-Service LxssManager | Restart-Service \033[0m"
    echo "\033[0;33m    and then run this bash script again. \033[0m"
    echo " "

    rm -rf /tmp/podman-run-$(id -u)/libpod/tmp
    # if repeated 3 times, the problems vanishes. Maybe because we have 3 containers in the pod.
    podman pod restart rust_dev_pod
    podman pod restart rust_dev_pod
fi

# this will execute on Debian in WSL2 and on bare metal.
podman pod restart rust_dev_pod
podman exec --user=root  rust_dev_vscode_cnt service ssh restart
podman pod list
podman ps -a

echo " "
echo "\033[0;33m    Test the SSH connection from bash terminal: \033[0m"
echo "\033[0;32m ssh -i ~/.ssh/rustdevuser_key -p 2201 rustdevuser@localhost \033[0m"
echo "\033[0;33m    Enter passphrase. \033[0m"
echo "\033[0;33m    The prompt should change to: rustdevuser@rust_dev_pod:~$ \033[0m"
echo " "
echo "\033[0;33m    Then close the SSH connection with: \033[0m"
echo "\033[0;32m exit \033[0m"

echo " "
echo "\033[0;33m    You can delete the pod and ALL of the DATA it contains: \033[0m"
echo "\033[0;32m podman pod rm -f rust_dev_pod \033[0m"

echo " "
echo "\033[0;33m    Just for your info: the files /etc/rc0.d/K44podman-stop and /etc/rc6.d/K44podman-stop \033[0m"
echo "\033[0;33m    will stop the pod before shutdown/reboot. \033[0m"

echo " "
