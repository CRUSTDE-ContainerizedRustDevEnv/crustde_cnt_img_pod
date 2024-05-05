# ~/rustprojects/pull_all.sh

cur_dir="/home/rustdevuser/rustprojects"

# check if script is run in the right directory
if [ $PWD != "$cur_dir" ]; then
  printf "\033[0;31m Error: Not in the right directory! \033[0m\n"
  printf "\033[0;33m    Usage: \033[0m\n"
  printf "\033[0;32m cd $cur_dir \033[0m\n"
  printf "\033[0;32m sh pull_all.sh \033[0m\n"
  exit 1;
fi

printf " \n"
printf "\033[0;33m    Script to pull (fetch+merge) all the changes from GitHub into local folder \033[0m\n"
printf " $cur_dir \n"
printf " \n"

# include hidden folders like .github
shopt -s dotglob

COUNTER=1
# loop throug directories
for d in */ ; do
    cd $cur_dir/$d/
    echo " "
    echo " $COUNTER. "
    COUNTER=$[$COUNTER +1]

    pwd
    git pull
done

cd $cur_dir/
