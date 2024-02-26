# $home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 should run on every startup

echo "Use sshadd to add often used SSH identities to the ssh-agent from $home\.ssh\sshadd.ps1."

New-Alias sshadd $home\.ssh\sshadd.ps1

echo " "
