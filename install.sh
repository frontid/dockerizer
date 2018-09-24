#!/usr/bin/env bash

if [[ $UID != 0 ]]; then
    echo "Please run it as sudo:"
    echo ''
    echo -e "\e[32msudo -s $0 $*"
    echo ''
    exit 1
fi

echo -e "Installing smartcd"

# Install smartcd if not installed.
if [ ! -f "$HOME/.smartcd_config" ]; then
  curl -L http://smartcd.org/install | bash
else
    echo -e "\e[32mCurrently installed\e[0m"
fi

echo ""
echo -e "Creating a traefik docker network"

network_exist="$(docker network ls | grep traefik_network)"

if [ -z "$network_exist" ]; then
    docker network create traefik_network
else
    echo -e "\e[32mTraefik docker network currently installed\e[0m"
fi

echo ""
echo -e "Installing/updating traefik dockerizer proxy"

traefik_path="/usr/local/bin/dk_traefik"
mkdir -p $traefik_path
cp setup_files/traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
cp -R setup_files/traefik $traefik_path

# ---------
echo ""
echo -e "Installing/updating dk cli"

cp setup_files/dockerizer_cli /usr/local/bin/dk
cp setup_files/dockerizer_cli_bash_autocomplete /etc/bash_completion.d/dk
chmod +x /usr/local/bin/dk

# ---------
echo ''
echo -e "\e[32m---- Everything installed! ----\e[0m"
