#!/bin/sh

# ~/.ssh/sshadd.sh for container
# List all private keys in ~/.ssh and offer ssh-add for them.
# The command argument can filter only for keys that contain the string.

printf "\n"
printf "\033[33m  Add often used SSH identity private keys to ssh-agent \033[0m\n"

printf "\n"
printf "\033[33m  The ssh-agent should be started already on login inside the ~/.bashrc script. \033[0m\n"
printf "\033[33m  <https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/blob/main/ssh_easy.md> \033[0m\n"
printf "\033[33m  It is recommended to use the ~/.ssh/config file to assign explicitly one ssh key to one ssh server. \033[0m\n"
printf "\033[33m  If not, ssh-agent will send all the keys to the server and the server could refute the connection because of too many bad keys. \033[0m\n"

# List the private key files inside ~/.ssh
printf "\n"
printf "\033[33m  List identities inside ssh-agent:  \033[0m\n"
for entry in ~/.ssh/*.pub 
do
  # remove suffix .pub
  full_file_name=${entry%.pub}
  # echo "$full_file_name"
  if [ -f $full_file_name ]; then
    # remove all characters except slash slashes
    only_slashes="$(echo $full_file_name | sed 's#[^/]##g')"
    # echo "$only_slashes"
    # count slashes
    num_of_slashes=${#only_slashes}
    # echo $num_of_slashes
    last_slash=$((num_of_slashes + 1))
    # echo $last_slash
    # remove prefix until the last slash
    file_name=$(echo $full_file_name |  cut -d '/' -f $last_slash )
    # echo "$file_name"
    ssh-add -l | grep -q `ssh-keygen -lf "$full_file_name" | awk '{print $2}'` && printf "$file_name\n"
  fi
done

printf "\n"
printf "\033[33m  Identities you can add to ssh-agent: \033[0m\n"
printf "\033[33m  Enter passphrase or press enter to skip. \033[0m\n"
printf "\n"

for entry in ~/.ssh/*.pub 
do
  # remove suffix .pub
  full_file_name=${entry%.pub}
  # echo "$full_file_name"
  if [ -f $full_file_name ]; then
    # remove all characters except slash slashes
    only_slashes="$(echo $full_file_name | sed 's#[^/]##g')"
    # echo "$only_slashes"
    # count slashes
    num_of_slashes=${#only_slashes}
    # echo $num_of_slashes
    last_slash=$((num_of_slashes + 1))
    # echo $last_slash
    # remove prefix until the last slash
    file_name=$(echo $full_file_name |  cut -d '/' -f $last_slash )
    # echo "$file_name"
    if  [ $# -eq 0 ] || (echo "$file_name" | grep -q "$1") ; then
      ssh-add -l | grep -q `ssh-keygen -lf "$full_file_name" | awk '{print $2}'` || (printf "  \033[33m ssh-add -t 1h $full_file_name \033[0m\n" & ssh-add -t 1h $full_file_name)
    else
      ssh-add -l | grep -q `ssh-keygen -lf "$full_file_name" | awk '{print $2}'` || printf "Skip by argument: $file_name \n"
    fi
  fi
done

printf "\n"
printf "\033[33m  The keys are set to expire in 1 hour. \033[0m\n"
printf "\033[33m  For security, when you are finished using the keys, remove them from the ssh-agent with: \033[0m\n"
printf "\033[32mssh-add -D \033[0m\n"
printf "\n" 
printf "\033[33m  List public fingerprints inside ssh-agent: \033[0m\n"
printf "\033[32mssh-add -l \033[0m\n"
printf "\n"
printf "\033[33m  List identities inside ssh-agent:  \033[0m\n"
for entry in ~/.ssh/*.pub 
do
  # remove suffix .pub
  full_file_name=${entry%.pub}
  # echo "$full_file_name"
  if [ -f $full_file_name ]; then
    # remove all characters except slash slashes
    only_slashes="$(echo $full_file_name | sed 's#[^/]##g')"
    # echo "$only_slashes"
    # count slashes
    num_of_slashes=${#only_slashes}
    # echo $num_of_slashes
    last_slash=$((num_of_slashes + 1))
    # echo $last_slash
    # remove prefix until the last slash
    file_name=$(echo $full_file_name |  cut -d '/' -f $last_slash )
    # echo "$file_name"
    ssh-add -l | grep -q `ssh-keygen -lf "$full_file_name" | awk '{print $2}'` && printf "$file_name\n"
  fi
done

printf "\n"
