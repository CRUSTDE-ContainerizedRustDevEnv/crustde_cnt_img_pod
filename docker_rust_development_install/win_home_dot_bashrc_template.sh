# .bashrc is used by git-bash.exe to start a session
# Here we start ssh-agent.exe in a background process that is accessible from windows.
# It is used by ssh client, git and VSCode remote extension.

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" | /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    echo "Starting ssh-agent as a windows process in the background in Task Manager"
    agent_start
    echo "Setting Windows SSH user environment variables (pid: $SSH_AGENT_PID, sock: $SSH_AUTH_SOCK)"
    setx SSH_AGENT_PID "$SSH_AGENT_PID"
    setx SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
fi
echo " "
echo "Add often used SSH identity private keys to ssh-agent"
echo " "
echo "The ssh-agent should be started already on git-bash start inside the ~/.bashrc script."
echo "The ssh-agent runs as a windows process in the background."
echo "It stores the keys in memory until the process is terminated."
echo "When finished using the keys, you can stop the process 'ssh-agent.exe'."
echo " "
echo "It is recommanded to use the ~/.ssh/config file to assign explicitly one ssh key to one ssh server."
echo "If not, ssh-agent will send all the keys to the server and the server could refute the connection because of too many bad keys."
echo " "
echo "ssh-add //wsl.localhost/Debian/home/luciano/.ssh/localhost_2201_rustdevuser_ssh_1"
echo "ssh-add //wsl.localhost/Debian/home/luciano/.ssh/github_com_git_ssh_1"
echo "ssh-add //wsl.localhost/Debian/home/luciano/.ssh/bestia_dev_luciano_bestia_ssh_1"
echo " "
echo "For security, when you are finished using the keys, remove them from the ssh-agent with:"
echo "ssh-add -D"
echo " "
echo "List public fingerprints inside ssh-agent:"
echo "ssh-add -l"
ssh-add -l
echo " "

unset env
