#!/bin/sh

# ~/.ssh/sshadd.sh for container
# Inside this template, replace the words your_key_for_github_ssh_1, your_key_for_webserver_ssh_1 and your_key_for_github_api_token_ssh_1
# with your identity file names for the ssh private key.

printf " \n"
printf "  \033[33m   Add often used SSH identity private keys to ssh-agent \033[0m\n"
printf "  \033[33m   If you add an argument: 'github' or 'your_webserver' or 'github_api_token' you will add only that credential. \033[0m\n"

printf " \n"
printf "  \033[33m   The ssh-agent should be started already on login inside the ~/.bashrc script. \033[0m\n"
printf "  \033[33m <https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod/blob/main/ssh_easy.md> \033[0m\n"
printf "  \033[33m   It is recommended to use the ~/.ssh/config file to assign explicitly one ssh key to one ssh server. \033[0m\n"
printf "  \033[33m   If not, ssh-agent will send all the keys to the server and the server could refute the connection because of too many bad keys. \033[0m\n"

printf " \n"
# check the content of ~/.ssh/config if it contains all the ssh keys
cat ~/.ssh/config | grep -q "~/.ssh/your_key_for_github_ssh_1" || printf "  \033[31m   The ~/.ssh/config does not contain the identity ~/.ssh/your_key_for_github_ssh_1. \033[0m\n"
cat ~/.ssh/config | grep -q "~/.ssh/your_key_for_webserver_ssh_1" || printf "  \033[31m   The ~/.ssh/config does not contain the identity ~/.ssh/your_key_for_webserver_ssh_1. \033[0m\n"
cat ~/.ssh/config | grep -q "~/.ssh/your_key_for_github_api_token_ssh_1" || printf "  \033[31m   The ~/.ssh/config does not contain the identity ~/.ssh/your_key_for_github_api_token_ssh_1. \033[0m\n"


if [ $# -eq 0 ] || [ $1 = "github" ]; then
    # add if key not yet exist in ssh-agent for git@github.com
    ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/your_key_for_github_ssh_1 | awk '{print $2}'` || (printf "  \033[33m github \033[0m\n" & ssh-add -t 1h ~/.ssh/your_key_for_github_ssh_1)
fi

if [ $# -eq 0 ] || [ $1 = "your_webserver" ]; then
    # add if key not yet exist in ssh-agent for your_username@your_webserver
    ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/your_key_for_webserver_ssh_1 | awk '{print $2}'` || (printf "  \033[33m your_webserver \033[0m\n" & ssh-add -t 1h ~/.ssh/your_key_for_webserver_ssh_1)
fi

if [ $# -eq 0 ] || [ $1 = "github_api_token" ]; then
    # add if key not yet exist in ssh-agent for your_key_for_github_api_token_ssh_1
    ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/your_key_for_github_api_token_ssh_1 | awk '{print $2}'` || (printf "  \033[33m github_api_token \033[0m\n" & ssh-add -t 1h ~/.ssh/your_key_for_github_api_token_ssh_1)
fi

printf " \n"
printf "  \033[33m   The keys are set to expire in 1 hour. \033[0m\n"
printf "  \033[33m   For security, when you are finished using the keys, remove them from the ssh-agent with: \033[0m\n"
printf "\033[32m ssh-add -D \033[0m\n"
printf " \n" 
printf "   \033[33m   List public fingerprints inside ssh-agent: \033[0m\n"
printf "\033[32m ssh-add -l \033[0m\n"
ssh-add -l

printf " \n"
