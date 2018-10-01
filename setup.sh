#!/usr/bin/env bash

# Include this folder into smartcd if is not included.
if [ ! -f "$HOME/.smartcd/scripts$PWD" ]; then
  mkdir -p "$HOME/.smartcd/scripts$PWD"
  echo autostash PATH=$PWD/bin:$PATH >> "$HOME/.smartcd/scripts$PWD/bash_enter"
fi

# Initialize smartcd.
source $HOME/.smartcd_config
source $HOME/.smartcd/scripts$PWD/bash_enter

echo ''
echo -e "\e[32mSetup finished.\e[0m"
