#!/usr/bin/env bash

echo ''
echo -e "\e[31mEste es el instalador del dockerizador. Si ya lo tienes funcionando (porque en algún momento lo instalaste para otro proyecto) no hace falta lanzarlo para cada nuevo proyecto.\e[0m"
echo -e "\e[31mSi tu caso es el anterior, lee README.md apartado 'Setup project'.\e[0m"
echo ''

read -p "Si aún así quieres ejecutar el proceso de setup presiona ENTER (o CTRL + C para cancelar)."
echo ''

# Install smartcd if not installed.
if [ ! -f "$HOME/.smartcd_config" ]; then
  curl -L http://smartcd.org/install | bash
fi

# Include this folder into smartcd if is not included.
if [ ! -f "$HOME/.smartcd/scripts$PWD" ]; then
  mkdir -p "$HOME/.smartcd/scripts$PWD"
  echo autostash PATH=$PWD/bin:$PATH >> "$HOME/.smartcd/scripts$PWD/bash_enter"
fi

# Initialize smartcd.
source $HOME/.smartcd_config
source $HOME/.smartcd/scripts$PWD/bash_enter

# ---------
echo ''
# ---------

echo -e "Vamos a instalar el traefik global (es el proxy que va a enrutar las peticiones de todos los contenedores)"

echo -e "Creando la red compartida de traefik (por si no existe)"
network_exist="$(docker network ls | grep traefik_network)"

if [ -z "$network_exist" ]; then
    docker network create traefik_network
fi

original_path=$PWD
user_share_path="$HOME/.local/share"
traefik_path="$user_share_path/traefik"
mkdir -p $traefik_path

cp setup_files/traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
cp -R setup_files/traefik $traefik_path
cd $traefik_path
docker-compose up -d
cd $original_path
echo ''

# ---------
echo ''
echo -e "\e[32mAcabamos!\e[0m"
echo ''
echo -e "Ahora solo tienes que configurar el archivo .env y arrancar docker."
echo -e "No olvides pasarle este archivo a tus colegas para tener todos el mismo entorno de desarrollo para este proyecto."
