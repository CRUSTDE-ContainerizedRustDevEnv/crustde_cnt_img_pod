# SSH easy

## Use SSH connection in Linux for remote work and git

It is recommended to use the `~/.ssh/config` file to assign explicitly one SSH key to one SSH server.  
If not, SSH will send all the keys to the server and the server could refute the connection because of too many bad keys.

Write the SSH connection details in `~/.ssh/config`:

```bash
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_com_bestia_dev_git_ssh_1v_git_ssh_1v_git_ssh_1
    IdentitiesOnly yes
```

The IdentitiesOnly yes is required to prevent the SSH default behavior of sending the identity file matching the default filename for each protocol. If you have a file named `~/.ssh/id_rsa` that will get tried BEFORE your `~/.ssh/github` without this option.

## ssh-agent

Every time I connect over SSH I must input the passphrases for my SSH identity. Even `git push` works over SSH, so every time I have to input the password. This is great for security, but it is an awful user experience. You can choose to be less secure with some SSH keys and be more productive with ssh-agent. Be aware of the risks. Your choice.  

Git comes with `ssh-agent` and I could use it to avoid retyping the passphrase every time. ssh-agent asks for the passphrase only once and then stores securely the unencrypted private key in memory.  

In the `~/.bashrc` file start the ssh-agent in the background:

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
printf "Use the global command 'sshadd' to simply add your SSH keys to ssh-agent $SSH_AGENT_PID.\n"
alias sshadd="printf 'sh ~/.ssh/sshadd.sh\n'; sh ~/.ssh/sshadd.sh"
```

Now you can use `ssh-add` to add your identity to the agent. So you have to write your passphrase only once.  
It is even easier if you prepare a little bash script with the ssh keys you often use in the file `~/.ssh/sshadd.sh`

```bash
#!/bin/sh

printf "   Bash script to add your private SSH keys to ssh_agent.\n"
# The ssh-agent is started already on login inside the ~/.bashrc script.
# Replace the words github_com_bestia_dev_git_ssh_1 and your_key_for_webserver_ssh_1 with your file names.
# The keys are restricted only to explicit servers/hosts in the ~/.ssh/config file.
# The keys will expire in 1 hour.

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/github_com_bestia_dev_git_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/github_com_bestia_dev_git_ssh_1

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/your_key_for_webserver_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/your_key_for_webserver_ssh_1

printf "   List public fingerprints inside ssh-agent:\n"
printf "   ssh-add -l\n"
ssh-add -l

printf " \n"

```

After you enter the passphrase, it will remember it until the terminal is open or you remove the key from the agent with `ssh-add -D`.  
When you open the terminal again, you will have to run the script again and enter the passphrase again.
