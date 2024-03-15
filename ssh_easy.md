# SSH easy

## Use SSH connection for remote work and git

It is preferred to use the SSH connection for remote work and for git.  
Write the ssh connection details in ~/.ssh/config:

```bash
Host github_com_git_ssh_1
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_com_git_ssh_1
```

In the ~/.bashrc file start the agent in the background:

```bash
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
echo "Use the global command 'sshadd' to simply add your SSH keys to ssh-agent $SSH_AGENT_PID."
alias sshadd="echo sh ~/.ssh/sshadd.sh; sh ~/.ssh/sshadd.sh"
```

Now you can use `ssh-add` to add your identity to the agent. So you have to write your passcode only once.
It is even easier if you prepare a little bash script with the ssh keys you often use in the file ~/.ssh/sshadd.sh

```bash
#!/bin/sh

echo "   Bash script to add your private SSH keys to ssh_agent."
# The ssh-agent is started already on login inside the ~/.bashrc script.
# Replace the words github_com_git_ssh_1 and bestia_dev_luciano_bestia_ssh_1 with your file names.
# The keys are restricted only to explicit servers/hosts in the ~/.ssh/config file.
# The keys will expire in 1 hour.

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/github_com_git_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/github_com_git_ssh_1

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/bestia_dev_luciano_bestia_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/bestia_dev_luciano_bestia_ssh_1

echo "   List public fingerprints inside ssh-agent:"
echo "   ssh-add -l"
ssh-add -l

echo " "

```
