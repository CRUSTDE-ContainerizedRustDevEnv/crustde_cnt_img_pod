#!/bin/dash

# /usr/bin/entrypoint.sh
# This is a Debian Slim container, so shebang /bin/dash is appropriate for scripting.

# Before calling 'podman create', modify this script to your needs.
#    Make the local script file executable before copying into the container:
# sudo chmod +x ~/rustprojects/crustde_cnt_img_pod/create_and_push_container_images/postgres_entrypoint.sh

#    First 'create' the container, copy the entrypoint file and then start the container.
#    Multiline block comment in bash script to run all together in bash:
<<'###BLOCK-COMMENT'
clear;
cd ~/rustprojects/crustde_cnt_img_pod/create_and_push_container_images
printf "\033[0;33m    Show existing containers \033[0m\n";
podman ps -a;
printf "\033[0;33m    Remove old container \033[0m\n";
podman rm -f crustde_postgres_cnt;
printf "\033[0;33m    Podman create \033[0m\n";
podman create --name crustde_postgres_cnt -p 5450:5450 -p 5460:5460 --entrypoint /usr/bin/entrypoint.sh docker.io/bestiadev/crustde_postgres_img:postgres17;
printf "\033[0;33m    Copy entrypoint.sh create \033[0m\n";
podman cp ~/rustprojects/crustde_cnt_img_pod/create_and_push_container_images/postgres_entrypoint.sh crustde_postgres_cnt:/usr/bin/entrypoint.sh ;
printf "\033[0;33m    Podman start \033[0m\n";
podman start crustde_postgres_cnt;
printf "\033[0;33m    Read the log with: podman logs crustde_postgres_cnt \033[0m\n";  
###BLOCK-COMMENT

#   Connect from Debian host of the container:
# psql -h localhost -p 5450 -U postgres -W
# SHOW cluster_name;
# psql -h localhost -p 5460 -U postgres -W
# SHOW cluster_name;

printf "\033[0;33m    Running container crustde_postgres_cnt \033[0m\n"

printf " \n"
printf "\033[0;33m    Create and run new clusters using the debian wrapper tool pg_createcluster: \033[0m\n"

printf " \n"
printf "\033[0;33m    cluster 'dev_01' on port '5450' \033[0m\n"
printf "\033[0;33m    data in /var/lib/postgresql/17/dev_01 \033[0m\n"
printf "\033[0;33m    conf in /etc/postgresql/17/dev_01 \033[0m\n"
printf "\033[0;33m    log in /var/log/postgresql/postgresql-17-dev_01.log \033[0m\n"
pg_createcluster --port=5450 17 dev_01;

printf "\033[0;33m    Change the line #listen_addresses = 'localhost' to '*' in /etc/postgresql/17/dev_01/postgresql.conf \033[0m\n"
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/17/dev_01/postgresql.conf

printf "\033[0;33m    Change the line in /etc/postgresql/17/dev_01/pg_hba.conf from 127.0.0.1 to 0.0.0.0 \033[0m\n"
sed -i "s/host    all             all             127.0.0.1\/32            scram-sha-256/host    all             all             0.0.0.0\/0            md5/g" /etc/postgresql/17/dev_01/pg_hba.conf

pg_ctlcluster 17 dev_01 start;

printf "\033[0;33m    Set password for postgres user using local peer connection over unix socket \033[0m\n"
psql -p 5450 -c  "ALTER USER postgres WITH PASSWORD 'Passw0rd';"

#    Check the log
# podman exec crustde_postgres_cnt cat  /var/log/postgresql/postgresql-17-dev_01.log

#    Connection rule 'listen_addresses' in postgresql.conf 
# podman exec -it crustde_postgres_cnt   psql -p 5450
# show listen_addresses;
# SHOW config_file;
# podman exec -it crustde_postgres_cnt   nano /etc/postgresql/17/dev_01/postgresql.conf
# podman cp crustde_postgres_cnt:/etc/postgresql/17/dev_01/postgresql.conf ./postgresql.conf

#    The rules who can connect to the cluster is in the file /etc/postgresql/17/dev_01/pg_hba.conf
# podman exec -it crustde_postgres_cnt   nano /etc/postgresql/17/dev_01/pg_hba.conf
# podman cp crustde_postgres_cnt:/etc/postgresql/17/dev_01/pg_hba.conf ./pg_hba.conf
#    After changes, to reload conf: 
# podman exec -it crustde_postgres_cnt   psql -p 5450
# SELECT pg_reload_conf();
#    To see the effective rules in psql: 
# TABLE pg_hba_file_rules;

#    Run psql from the Debian host of the container:
# psql -h localhost -p 5450 -U postgres -W

printf " \n"
printf "\033[0;33m    cluster 'test_01' on port '5460' \033[0m\n"
printf "\033[0;33m    data in /var/lib/postgresql/17/test_01 \033[0m\n"
printf "\033[0;33m    conf in /etc/postgresql/17/test_01 \033[0m\n"
printf "\033[0;33m    log in /var/log/postgresql/postgresql-17-test_01.log \033[0m\n"
pg_createcluster --port=5460 17 test_01;

printf "\033[0;33m    Change the line #listen_addresses = 'localhost' to '*' in /etc/postgresql/17/test_01/postgresql.conf \033[0m\n"
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/17/test_01/postgresql.conf

printf "\033[0;33m    Change the line in /etc/postgresql/17/test_01/pg_hba.conf from 127.0.0.1 to 0.0.0.0 \033[0m\n"
sed -i "s/host    all             all             127.0.0.1\/32            scram-sha-256/host    all             all             0.0.0.0\/0            md5/g" /etc/postgresql/17/test_01/pg_hba.conf

pg_ctlcluster 17 test_01 start;

printf "\033[0;33m    Set password for postgres user using local peer connection over unix socket \033[0m\n"
psql -p 5460 -c  "ALTER USER postgres WITH PASSWORD 'Passw0rd';"


printf " \n"
pg_lsclusters

# container runs only until there is a foreground process
# this will make it run forever or at least 24 hours. Enough for development.
sleep infinity
