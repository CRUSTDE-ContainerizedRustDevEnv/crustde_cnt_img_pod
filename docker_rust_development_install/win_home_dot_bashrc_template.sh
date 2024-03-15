# .bashrc is used by git-bash.exe to start a session

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" | /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    echo "Starting ssh-agent as a windows process in the background"
    agent_start
    echo "Setting Windows SSH user environment variables (pid: $SSH_AGENT_PID, sock: $SSH_AUTH_SOCK)"
    setx SSH_AGENT_PID "$SSH_AGENT_PID"
    setx SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
fi

echo "Add ssh keys manually when needed:"
echo "ssh-add ~/.ssh/localhost_2201_rustdevuser_ssh_1"
echo "ssh-add ~/.ssh/github_com_git_ssh_1"
echo "ssh-add ~/.ssh/bestia_dev_luciano_bestia_ssh_1"
echo " "
echo "List keys in ssh-agent with:"
echo "ssh-add -l"
ssh-add -l
echo " "
echo "The ssh-agent runs as a windows process in the background."
echo "It stores the keys in memory until the process is terminated."
echo "When finished using the keys, you can stop the process 'ssh-agent.exe'"
echo "or remove keys manually from ssh-agent with:"
echo "ssh-add -D"

unset env
