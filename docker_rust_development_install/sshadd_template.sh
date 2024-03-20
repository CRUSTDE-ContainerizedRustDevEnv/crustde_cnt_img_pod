#!/bin/sh

# ~/.ssh/sshadd.sh
# Inside this template, replace the words github_com_git_ssh_1 and your_key_for_webserver_ssh_1 
# with your identity file names for the ssh private key.

echo "  \033[33m Add often used SSH identity private keys to ssh-agent \033[0m"
echo " "
echo "  \033[33m The ssh-agent should be started already on login inside the ~/.bashrc script. \033[0m"
echo "  \033[33m <https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/docker_rust_development/blob/main/ssh_easy.md> \033[0m"
echo "  \033[33m It is recommended to use the ~/.ssh/config file to assign explicitly one ssh key to one ssh server. \033[0m"
echo "  \033[33m If not, ssh-agent will send all the keys to the server and the server could refute the connection because of too many bad keys. \033[0m"

# check the content of ~/.ssh/config if it contains the ssh keys
cat ~/.ssh/config | grep -q "~/.ssh/github_com_git_ssh_1" || echo "The ~/.ssh/config does not contain the identity ~/.ssh/github_com_git_ssh_1."
cat ~/.ssh/config | grep -q "~/.ssh/your_key_for_webserver_ssh_1" || echo "The ~/.ssh/config does not contain the identity ~/.ssh/your_key_for_webserver_ssh_1."

# add if key not yet exist in ssh-agent for git@github.com
ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/github_com_git_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/github_com_git_ssh_1

# add if key not yet exist in ssh-agent for your_username@your_webserver
ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/your_key_for_webserver_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/your_key_for_webserver_ssh_1

echo "  \033[33m The keys are set to expire in 1 hour. \033[0m"
echo "  \033[33m For security, when you are finished using the keys, remove them from the ssh-agent with: \033[0m"
echo "\033[32mssh-add -D \033[0m"
echo " " 
echo "   \033[33m List public fingerprints inside ssh-agent: \033[0m"
echo "\033[32mssh-add -l \033[0m"
ssh-add -l

echo " "
