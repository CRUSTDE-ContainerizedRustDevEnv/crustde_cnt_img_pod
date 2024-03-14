# $HOME\.ssh\sshadd.ps1

write-host "Add often used SSH identity private keys to ssh-agent" -foregroundcolor "yellow"
write-host " " -foregroundcolor "yellow"
write-host "The ssh-agent should be already started on Windows startup." -foregroundcolor "yellow"

write-host "It is recommanded to use the ~/.ssh/config file to assign explicitly one ssh key to one ssh server." -foregroundcolor "yellow"
write-host "If not, ssh-agent will send all the keys to the server and the server could refute the connection because of too many bad keys." -foregroundcolor "yellow"

# sshadd for Windows will store the ssh passcode for CRDE - Containerized Rust Development Environment
# sshadd will avoid unnecessary typing of passcode everytime a Rust project is opened in VSCode. 
# ssh key For rustdevuser@localhost:2201
ssh-add C:\Users\luciano\.ssh\localhost_2201_rustdevuser_ssh_1

write-host "   The keys are set to expire in 1 hour." -foregroundcolor "yellow"
write-host "   For security, when you are finished using the keys, remove them from the ssh-agent with:" -foregroundcolor "yellow"
write-host "ssh-add -D" -foregroundcolor "green"
write-host " " 
write-host "    List public fingerprints inside ssh-agent:" -foregroundcolor "yellow"
write-host "ssh-add -l" -foregroundcolor "green"
ssh-add -l

write-host " "
