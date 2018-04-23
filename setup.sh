#!/usr/bin/env bash

while [[ -z "$repo" ]]
do
  read -p "Indica la URL del repositorio (Ej:  git@github.com:githubtraining/hellogitworld.git): " repo
done

export repo

while [[ -z "$branch" ]]
do
  read -p "Especifica la rama en la que vas a trabajar: " branch
done

export branch

echo ''
echo -e "Clonando el proyecto real sobre el que vamos a trabajar dentro del directorio _html"
git clone -b $branch $repo html
echo ''

# Si existe un archivo de configuración preguntamos si lo vamos a usar o si quiere pasar por el wizard.
if [ ! -f "_html/.env" ]; then
  # Si no existe el archivo .env abortamos.
  echo -e "\e[31mNo hemos econtrado el archivo .env en el repositorio.\e[0m"
  exit 1
fi

# ---------
echo ''
# ---------

# Install smartcd if not installed.
if [ ! -f "$HOME/.smartcd_config" ]; then
  read -p "A continuación se va a instalar smartcd. Deja por defecto a todas las preguntas que te haga y cuando acabe seguimos con el proceso de instalación."
  curl -L http://smartcd.org/install | bash
fi

# Include this folder into smartcd if is not included.
if [ ! -f "$HOME/.smartcd/scripts$PWD" ]; then
  mkdir -p "$HOME/.smartcd/scripts$PWD"
  echo autostash PATH=$PWD/bin:$PATH >> "$HOME/.smartcd/scripts$PWD/bash_enter"

  # Phpstorm local terminal fails to autostash bash_enter when you change the
  # project or open a new terminal tab. This addition to .bashrc ensure the script gets run.
  echo -n source "$HOME/.smartcd/scripts$PWD/bash_enter >> /dev/null" >> "$HOME/.bashrc"
fi

# Initialize smartcd.
source $HOME/.smartcd_config
source $HOME/.smartcd/scripts$PWD/bash_enter

# ---------
echo ''
# ---------

# Generamos el docker.
./make/build-docker-compose.sh


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

cp make/traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
cp -R make/traefik $traefik_path
cd $traefik_path
docker-compose up -d
cd $original_path
echo ''

# ---------

echo ''
echo ''
echo ''
echo -e "\e[32mAcabamos!\e[0m"
echo -e "Apunta esto en algun lado que te va a ser útil:"
echo ''

echo -e "La url de tu proyecto es \e[32mhttp://$PROJECT_BASE_URL\e[0m (accesible desde https)"
echo -e "El phpmyadmin es \e[32mhttp://pma.$PROJECT_BASE_URL\e[0m"
echo -e "El usuario y clave de mysql es \e[32mdb / db (DB: db)\e[0m (si, todo db)"
