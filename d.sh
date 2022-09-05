#!/bin/sh

if grep -q "Host rust_dev_vscode_cnt" "$HOME/.ssh/config"; then
  echo "\033[0;33m    VSCode config for SSH already exists. \033[0m"
else
  echo "\033[0;33m    Add Host rust_dev_vscode_cnt to ~/.ssh/config \033[0m"
  echo 'Host rust_dev_vscode_cnt
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~\\.ssh\\rustdevuser_key
  IdentitiesOnly yes' 
fi