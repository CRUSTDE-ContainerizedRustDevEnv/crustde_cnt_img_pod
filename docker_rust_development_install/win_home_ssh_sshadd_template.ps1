# $HOME\.ssh\sshadd.ps1

echo "   Add often used SSH key identity to ssh-agent"
# The ssh-agent is started already on Windows startup.
# The keys are restricted only to explicit servers/hosts in the ~/.ssh/config file.
# The keys will expire in 1 hour. 
# A confirmation is requested from the user every time the added identities are used for authentication.

# sshadd for Windows will store the ssh passcode for CRDE - Containerized Rust Development Environment
# sshadd will avoid unnecessary typing of passcode everytime a Rust project is opened. 
# For rustdevuser@localhost:2201
ssh-add C:\Users\luciano\.ssh\rustdevuser_key

echo "   List public fingerprints inside ssh-agent:"
echo "   ssh-add -l"
ssh-add -l

echo " "
