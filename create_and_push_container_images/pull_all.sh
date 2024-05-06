#!/bin/sh

# ~/rustprojects/pull_all.sh
cur_dir="/home/rustdevuser/rustprojects"

printf " \n"
printf "\033[0;33m    Script to pull (fetch+merge) all the changes from GitHub into local folder \033[0m\n"
printf "\033[0;33m    $cur_dir \033[0m\n"
printf " \n"

# check if script is run in the right directory
if [ $PWD != "$cur_dir" ]; then
  printf "\033[0;31m Error: Not in the right directory! \033[0m\n"
  printf "\033[0;33m    Usage: \033[0m\n"
  printf "\033[0;32m cd $cur_dir \033[0m\n"
  printf "\033[0;32m sh pull_all.sh \033[0m\n"
  exit 1;
fi

COUNTER=1
# Loop through hidden and not hidden directories is not trivial
# Warning: the hidden directory must begin with . but we must avoid . and .. special meaning relative directories
# If the list is empty it returns an error that is than used as a folder name. Pipe the error messages away from the result.
for folder in $(ls -d $cur_dir/.[!.]*/ $cur_dir/*/ 2> /dev/null) ; do
    cd $folder
    printf "\n"
    printf " $COUNTER. "
    COUNTER=$(expr $COUNTER + 1)

    pwd
    git pull
done

cd $cur_dir/
