#!/usr/bin/env bash

if [[ $UID != 0 ]]; then
    echo "Please run it as sudo:"
    echo ''
    echo -e "\e[32msudo -s $0 $*"
    echo ''
    exit 1
fi

echo -e "Installing smartcd"
echo ""

# Install smartcd if not installed.
if [ ! -f "$HOME/.smartcd_config" ]; then
  curl -L http://smartcd.org/install | bash
fi


echo -e "Creating a traefik docker network"
echo ""

network_exist="$(docker network ls | grep traefik_network)"

if [ -z "$network_exist" ]; then
    docker network create traefik_network
fi

echo -e "Installing traefik dockerizer proxy"
echo ""

original_path=$PWD
user_share_path="/usr/local/bin"
traefik_path="$user_share_path/dk_traefik"
mkdir -p $traefik_path

cp setup_files/traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
cp -R setup_files/traefik $traefik_path
cd $traefik_path
docker-compose up -d
cd $original_path
echo ''

# ---------
echo -e "Installing dk cli"
echo ""

cp setup_files/dockerizer_cli /usr/local/bin/dk
cp setup_files/dockerizer_cli_bash_autocomplete /etc/bash_completion.d/dk
chmod +x /usr/local/bin/dk

# ---------
echo ''
echo -e "\e[32mEverything installed.!\e[0m"
