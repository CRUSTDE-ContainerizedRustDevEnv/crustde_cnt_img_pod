#!/bin/sh

echo " "
echo "\033[0;33m    Copy and reload modified squid config file. \033[0m"
echo "\033[0;33m    The script will use the files in the Working directory. \033[0m"
# repository: https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/crustde_cnt_img_pod

echo " "
echo "\033[0;33m    Copy squid.conf for customized ACL proxy permissions \033[0m"
podman cp etc_squid_squid.conf crustde_squid_cnt:/etc/squid/squid.conf

echo " "
echo "\033[0;33m    Restart the container \033[0m"
podman restart crustde_squid_cnt 

echo " "
echo "\033[0;33m    If the container does not start, then there is an error inside the modified config file. \033[0m"
podman ps -a

echo " "
echo "\033[0;33m    List squid access log \033[0m"
podman exec --user=root crustde_squid_cnt /bin/sh -c 'cat /var/log/squid/access.log'                                                    