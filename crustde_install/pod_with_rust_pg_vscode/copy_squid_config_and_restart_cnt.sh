#!/bin/sh

printf " \n"
printf "\033[0;33m    Copy and reload modified squid config file. \033[0m\n"
printf "\033[0;33m    The script will use the files in the Working directory. \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf " \n"
printf "\033[0;33m    Copy squid.conf for customized ACL proxy permissions \033[0m\n"
podman cp etc_squid_squid.conf crustde_squid_cnt:/etc/squid/squid.conf

printf " \n"
printf "\033[0;33m    Restart the container \033[0m\n"
podman restart crustde_squid_cnt 

printf " \n"
printf "\033[0;33m    If the container does not start, then there is an error inside the modified config file. \033[0m\n"
podman ps -a

printf " \n"
printf "\033[0;33m    List squid access log \033[0m\n"
podman exec --user=root crustde_squid_cnt /bin/sh -c 'cat /var/log/squid/access.log'                                                    