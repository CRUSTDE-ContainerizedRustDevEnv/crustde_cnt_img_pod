#!/bin/dash

# in debian /bin/sh is dash and not bash. 
# There are some small differences ex.[] instead of [[ ]]

echo " "
echo "\033[0;33m    Test the if statement in dash, not bash \033[0m"

# if both files already exist, don't need this step
if [ -f "$HOME/.ssh/personal_keys_and_settings.sh" ] && [ -f "$HOME/.ssh/sshadd.sh" ];
then
    echo " Found"    
else 
    echo "\033[0;33m    Not found   \033[0m"  
fi

echo ""
echo ""
