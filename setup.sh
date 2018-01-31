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
echo ''
# ---------

# Antes de iniciar el wizard vamos a necesitar el repo para saber si tiene un archivo de configuración.
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
echo -e "Clonando el proyecto real sobre el que vamos a trabajar dentro del directorio html"
git clone -b $branch $repo html
echo ''

# Si existe un archivo de configuración preguntamos si lo vamos a usar o si quiere pasar por el wizard.
if [ ! -f ".dockerizer-project.ini" ] && [ ! -f "html/.dockerizer-project.ini" ]; then
  # Si no existe le hacemos le damos.
  source ./make/questions-setup.sh
else

  while ! { test "$run_from_conf_file" = 'y' || test "$run_from_conf_file" = 'n'; }; do

    if [ -f ".dockerizer-project.ini" ]; then
      conf_file_location=".dockerizer-project.ini"
      echo -e "Archivo de configuración encontrado en \e[32mel dockerizador\e[0m"
    fi

    if [ -f "html/.dockerizer-project.ini" ]; then
      conf_file_location="html/.dockerizer-project.ini"
      echo -e "Archivo de configuración encontrado \e[32mcomiteado como parte del proyecto\e[0m"
    fi

    if [ -f ".dockerizer-project.ini" ] && [ -f "html/.dockerizer-project.ini" ]; then
      echo -e "Como hay mas de un archivo de configutración prevalece el que está comiteado en el proyecto."
    fi

    echo ''
    read -p "Actualmente existe un archivo de configuración con todos los parametros necesarios para echar a andar este proyecto. ¿Usamos el archivo de configuración (recomendado)? [Y/n]: " run_from_conf_file

    if [[ ${run_from_conf_file,,} = '' || ${run_from_conf_file,,} = 'y' ]]; then
      run_from_conf_file='y'
    elif [[ ${run_from_conf_file,,} = 'n' ]]; then
      run_from_conf_file='n'
    fi
  done

  if [[ $run_from_conf_file = 'y' ]]; then
    # Si ha decidido usar el archivo de configuración lo cargamos y seguimos.
    source $conf_file_location
    else
    # Si el usuario quiere omitir el archivo de configuración y pasar si o si por el wizard lo hacemos:
    source ./make/questions-setup.sh
  fi

fi


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

  # Phpstorm local terminal fails to autostash bash_enter when you change the
  # project or open a new terminal tab. This addition to .bashrc ensure the script gets run.
  echo source $HOME/.smartcd/scripts$PWD/bash_enter >> "$HOME/.bashrc"
fi

# Initialize smartcd.
source $HOME/.smartcd_config
source $HOME/.smartcd/scripts$PWD/bash_enter

echo ''
echo -e "Creando directorio de almacenamiento \e[32mstorage\e[0m (donde se alojará la DB)"
mkdir -p storage

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
./make/build-docker-compose.sh

# Guardamos todas las variables en un archivo (solo si no existe)
if [ ! -f ".dockerizer-project.ini" ]; then
  echo ""
  echo -e "\e[32m.dockerizer-project.ini\e[0m no existe. Creando."
  envsubst < "make/variables-template.ini" >> ".dockerizer-project.ini"
else
  echo ""
  echo -e "\e[32m.dockerizer-project.ini\e[0m ya existe no lo vamos a sobreescribir."
  echo -e "Si realmente quieres cambiar la configuración de este proyecto primero elimina el archivo."
fi

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
    echo -e "\e[32mhttp://$domain.apache.localhost:8000\e[0m (accesible desde https)"
    echo -e "\e[32mhttp://$domain.nginx.localhost:8000\e[0m (accesible desde https)"
    else
    echo -e "La url de tu proyecto es \e[32mhttp://$domain.$webserver.localhost:8000\e[0m (accesible desde https)"
fi

echo -e "El phpmyadmin es \e[32mhttp://$domain.pma.localhost:8000\e[0m"
echo -e "El usuario y clave de mysql es \e[32mdb / db (DB: db)\e[0m (si, todo db)"
echo -e "Para arrancar y parar el docker usa \e[32mdc up -d\e[0m y \e[32mdc stop\e[0m (dentro del directorio de tu proyecto en cualquier carpeta. No importa la ubicacion mientras estés dentro del proyecto)"
echo ''
echo 'Se ha creado un archivo con todas las opciones que seleccionaste en el wizard .dockerizer-project.ini'
echo 'Si quieres que el resto de los desarrolladores tengan la misma conf comitealo en el proyecto.'
echo ''
echo '¡A por ellos campeón!'
