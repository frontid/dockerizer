#!/usr/bin/env bash

rm -rf /tmp/dockerizer

echo "Installing dockerizer"

git clone https://github.com/frontid/dockerizer.git /tmp/dockerizer

echo "------------------------"
echo "Installing..."
echo "------------------------"

echo -e "Installing smartcd"

# Install smartcd if not installed.
if [ ! -f "$HOME/.smartcd_config" ]; then
  curl -L https://raw.githubusercontent.com/cxreg/smartcd/master/download-and-install | bash
else
    echo -e "\e[32mCurrently installed\e[0m"
fi

echo ""
echo -e "Creating a traefik docker network"

network_exist="$(docker network ls | grep traefik_default)"

if [ -z "$network_exist" ]; then
    docker network create traefik_default
else
    echo -e "\e[32mTraefik docker network currently installed\e[0m"
fi

echo ""
echo -e "Installing/updating traefik dockerizer proxy"

traefik_path="/usr/local/bin/dk_traefik"
sudo mkdir -p $traefik_path
sudo cp /tmp/dockerizer/setup_files/traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
sudo cp -R /tmp/dockerizer/setup_files/traefik $traefik_path

# ---------
echo ""
echo -e "Installing/updating dk cli"

sudo cp /tmp/dockerizer/setup_files/dockerizer_cli /usr/local/bin/dk
sudo cp /tmp/dockerizer/setup_files/dockerizer_cli_bash_autocomplete /etc/bash_completion.d/dk
sudo chmod +x /usr/local/bin/dk

# ---------
echo ''
echo -e "\e[32m---- Everything installed! ----\e[0m"
