#!/usr/bin/env bash

while ! { test "$answer" = 'y' || test "$answer" = 'n'; }; do
  read -p "¿Uninstall dockerizer? [N/y]: " answer
  
  if [[ ${answer,,} = '' || ${answer,,} = 'n' ]]; then
    exit 1
  elif [[ ${answer,,} = 'y' ]]; then
    docker stop proxy_traefik
    docker rm proxy_traefik
    docker rmi dk_traefik_traefik
    rm -rf .smartcd .smartcd_config
    sudo rm -rf /usr/local/bin/dk_traefik
    sudo rm /usr/local/bin/dk
    sudo rm /etc/bash_completion.d/dk
    echo -e "\e[32mEverything uninstalled\e[0m"
  fi
done

