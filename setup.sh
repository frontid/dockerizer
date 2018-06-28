#!/usr/bin/env bash

if [[ $UID != 0 ]]; then
    echo "Please run it as sudo:"
    echo ''
    echo -e "\e[32msudo -s $0 $*"
    echo ''
    exit 1
fi

# Include this folder into smartcd if is not included.
if [ ! -f "$HOME/.smartcd/scripts$PWD" ]; then
  mkdir -p "$HOME/.smartcd/scripts$PWD"
  echo autostash PATH=$PWD/bin:$PATH >> "$HOME/.smartcd/scripts$PWD/bash_enter"
fi

# Initialize smartcd.
source $HOME/.smartcd_config
source $HOME/.smartcd/scripts$PWD/bash_enter

# @todo remove when the perms get commited.
chmod +x bin/ -R

echo ''
echo -e "\e[32mSetup finished.\e[0m"
