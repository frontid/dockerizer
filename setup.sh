#!/usr/bin/env bash

# No veo necesario usar sudo para este script pero por
# las dudas aquí está. Descomentalo y a correr.
#if [[ $UID != 0 ]]; then
#   echo "Hey! usa este comando para iniciar el script:"
#    echo ''
#    echo -e "\e[32msudo -s $0 $*"
#    echo ''
#    exit 1
#fi

echo ''
echo ''
echo -e "\e[32mBienvenido. Vamos a instalar el entorno para tu proyecto."
echo -e "\e[32mPor favor ten a mano la url del repositorio del proyecto en el que vas a trabajar."
echo -e "\e[0m"
echo ''

# ---------

while [[ -z "$domain" ]]
do
  read -p "¿Como llamamos a este proyecto? (Ejemplo frontid, agora, google, etc): " domain
done

export domain


# ---------
echo ''
# ---------

while [[ -z "$repo" ]]
do
  read -p "Indica la URL del repositorio (Ej:  git@github.com:githubtraining/hellogitworld.git): " repo
done

export repo

# ---------
echo ''
# ---------

while [[ -z "$db" ]]
do
  read -p "Puedes indicar el path de la DB si quieres que la carguemos inicialmente(Ej: $HOME/Downloads/bkp-$domain.sql). O pulsa intro si quires saltarte este paso: " db

  # Exit loop if user just press enter.
  if [[ $db = '' ]]; then
    unset db
    break
  fi

  # Check provided file exit and copy to the needed location.
  if [ ! -f "$db" ]; then
    echo "No encuentro la base de datos."
    echo ""
    unset db
  fi
done

export db

# ---------
echo ''
# ---------

read -p "Si el repositorio tiene la aplicación web en un subdirectorio en lugar de en la raiz pon la ruta en el repositorio(Ej: web). O pulsa intro si la raiz del repositorio es la raiz de la aplicación web: " base_web_root

export base_web_root

# ---------
echo ''
# ---------

PS3="Especifica la versión de PHP que vas a usar: "
options=( '7.1-dev-3.3.1' '7.0-dev-3.3.1' '5.6-dev-3.3.1' '5.3-dev-3.3.1' )

select phpver in "${options[@]}" ; do 

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        export phpver
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done  

# ---------
echo ''
# ---------

PS3="Y el servidor http: "
options=( 'apache' 'nginx' 'both' )

select webserver in "${options[@]}" ; do 

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        export webserver
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done  

# ---------
echo ''
# ---------

PS3="Y la versión de MariaBD: "
options=( '10.1-x => compatible con MySQL 5.6' '10.2-x => Compatible con Mysql 5.7')

select mysqlver in "${options[@]}" ; do 

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
	mysqlver=$(echo $mysqlver| cut -d'-' -f 1)
        export mysqlver
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done  

echo $mysqlver

echo ''
echo -e "Esta el la configuración que nos queda:"
echo -e "Nombre del proyecto: \e[32m$domain\e[0m"
echo -e "Repositorio: \e[32m$repo\e[0m"
echo -e "DB inicial: \e[32m$db\e[0m"
echo -e "La aplicación web esta en: \e[32m$base_web_root\e[0m"
echo -e "Versión de PHP: \e[32m$phpver\e[0m"
echo -e "Servidor http: \e[32m$webserver\e[0m"
echo -e "Versión Mysql (MariaDB): \e[32m$mysqlver\e[0m"
echo ''

read -p "Si está todo bien presiona ENTER (o CTRL + C para cancelar y vuelve a empezar)."

# Install smartcd if not installed.
if [ ! -f "$HOME/.smartcd_config" ]; then
  read -p "A continuación se va a instalar smartcd. Deja por defecto a todas las preguntas que te haga y cuando acabe seguimos con el proceso de instalación."
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

echo ''
echo -e "Creando directorio de almacenamiento \e[32mstorage\e[0m (donde se alojará la DB)"
mkdir -p storage

echo ''
echo -e "Clonando el proyecto real sobre el que vamos a trabajar dentro del directorio html"
git clone $repo html

# If database should be copied.
if [ ! -z ${db+x} ]; then
  echo -e "Copiando la base de datos"
  mkdir -p mariadb-init
  cp $db mariadb-init/
fi

echo ''
echo -e "Ajustando permisos de directorios para que no haya problemas de permisos entre docker y el host"
setfacl -dRm u:$USER:rwX -dRm u:21:rX -dRm u:82:rwX . && setfacl -Rm u:$USER:rwX -Rm u:21:rX -Rm u:82:rwX .


# Generamos el docker.
./build-docker-compose.sh

# ---------
echo ''
# ---------

echo -e "Vamos a instalar el traefik global (es el proxy que va a enrutar las peticiones de todos los contenedores)"

# @todo averiguar si existe antes de intentar crearla.
echo -e "Creando la red compartida de traefik (por si no existe)"
docker network create traefik_network

original_path=$PWD
user_share_path="/home/$USER/.local/share"
traefik_path="$user_share_path/traefik"
mkdir -p $traefik_path

cp docker-templates/traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
cp -R traefik $traefik_path
cd $traefik_path
docker-compose up -d
cd $original_path
echo ''

# ---------

while ! { test "$rundocker" = 'y' || test "$rundocker" = 'n'; }; do
  read -p "¿Arrancamos docker? [Y/n]: " rundocker
  
  if [[ ${rundocker,,} = '' || ${rundocker,,} = 'y' ]]; then
    rundocker='y'
  elif [[ ${rundocker,,} = 'n' ]]; then
    rundocker='n'
  fi
done

if [[ $rundocker = 'y' ]]; then
    dc up -d
fi

# ---------

echo ''
echo ''
echo ''
echo -e "\e[32mAcabamos!\e[0m"
echo -e "Anota esto en algun lado que te va a ser útil:"
echo ''

if [ $webserver = "both" ]; then
    echo -e "Las URL de tus proyectos son:"
    echo -e "http://$domain.apache.localhost:8000"
    echo -e "http://$domain.nginx.localhost:8000"
    echo -e "https://$domain.apache.localhost:4430"
    echo -e "https://$domain.nginx.localhost:4430"
    else
    echo -e "La url de tu proyecto es \e[32mhttp://$domain.$webserver.localhost:8000\e[0m"
    echo -e "La url de tu proyecto es \e[32mhttps://$domain.$webserver.localhost:4430\e[0m"
fi

echo -e "El phpmyadmin es \e[32mhttp://$domain.pma.localhost:8000\e[0m"
echo -e "El usuario y clave de mysql es \e[32mdrupal / drupal (DB: drupal)\e[0m (si, todo drupal)"
echo -e "Para arrancar y parar el docker usa \e[32mdc up -d\e[0m y \e[32mdc stop\e[0m (dentro del directorio de tu proyecto en cualquier carpeta. No importa la ubicacion mientras estés dentro del proyecto)"
echo ''
echo '¡A por ellos campeón!'
