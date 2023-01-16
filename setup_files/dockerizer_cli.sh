#!/bin/bash
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

_check_requirements() {
  # Consider requirements would be met
  REQUIREMENTS=1

  # Before moving to a new directory save where we are
  BACKDIR=`pwd`

  # Go to project home
  _go_home_dir

  docker_compose_plugin=$(docker compose version)
  if [ $? = 1 ]; then
    echo -e "${BRed}Please install docker compose plugin and try again: https://docs.docker.com/compose/install/linux/${Color_Off}"
    REQUIREMENTS=0
  fi

  # We should always have a .docker.env in the project
  if [ ! -f web/.docker.env ]; then
    echo -e "${BRed}Your project must provide \".docker.env\" file in order to work with dockerizer. Please see https://frontid.github.io/dockerizer/dockerenv/${Color_Off}"
    REQUIREMENTS=0
  fi

  cd $BACKDIR > /dev/null
  if [ $REQUIREMENTS = 0 ]; then
    exit 1
  fi 

}

# Move to project home folder.
_go_home_dir() {
  bin_path=$(which _command_wrapper_exec)

  if [ -z bin_path ]; then
      project_path="."
  else
      project_path="$(dirname $bin_path)/../"
  fi

  cd $project_path > /dev/null
}

# Finds the .docker.env with the override and prepares it for running docker
_prepare_env_file() {
  # Before moving to a new directory save where we are
  BACKDIR=`pwd`

  # Go to project home
  _go_home_dir

  ENV_FILES=''

  # We would load default variables that will be overriden with other .env files
  if [ -e .docker.default.env ]; then
    ENV_FILES="$ENV_FILES ./.docker.default.env"
  fi

  # We should always have a .docker.env in the project
  if [ -e web/.docker.env ]; then
    ENV_FILES="$ENV_FILES web/.docker.env"
  fi

  # We could have some specific override for the developer/machine
  if [ -e web/.docker.override.env ]; then
    ENV_FILES="$ENV_FILES web/.docker.override.env"
  fi

  # We could also need to load specific docker enabled/disabled features
  if [ -e .docker.local.env ]; then
    ENV_FILES="$ENV_FILES ./.docker.local.env"
  fi

  # Load them all!
  paste -s -d '\n' $ENV_FILES > ./.env

  # Return to previous dir
  cd $BACKDIR > /dev/null
}

# Stores data in the local docker environment
# Receives two parameters KEY VALUE
update_local_env() {
  # Before moving to a new directory save where we are
  BACKDIR=`pwd`
  # Go to project home
  _go_home_dir

  KEY=$1
  VALUE=$2
  if [ ! -f .docker.local.env ]; then
    touch ./.docker.local.env
  fi

  set -o allexport
  source ./.docker.local.env
  set +o allexport

  # If key is not defined
  if [ ! -n "${!KEY}" ]; then
    echo -e "$KEY='$VALUE'" >> ./.docker.local.env
  else
    sed -i './.docker.local.env' -e "/^$KEY=/s/=.*/=\'$VALUE\'/"
  fi

  # Return to previous dir
  cd $BACKDIR > /dev/null
}

_load_env_variables() {
  # Before moving to a new directory save where we are
  BACKDIR=`pwd`
  # Go to project home
  _go_home_dir

  # Prepare .env file
  _prepare_env_file

  # Load env file
  if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
  else
    echo "NOT FOUND ENV `pwd`"

  fi

  # Return to previous dir
  cd $BACKDIR > /dev/null
}

# Check if the .docker.env (and optionally .docker.override.env).
# and run docker-compose commands.
_docker_project() {

 _check_requirements

 _load_env_variables
 # Before moving to a new directory save where we are
 BACKDIR=`pwd`

 # Go to project home
  _go_home_dir

  # Load default variables
  ID_RSA="${ID_RSA:-~/.ssh/id_rsa}"
  SSH_CONFIG="${SSH_CONFIG:-~/.ssh/config}"
  PROFILES="${PROFILES:-}"
	CONTAINER=$2

  if [[ "$2" == "profiles" ]]; then
    echo -e "Loading specific profiles: ${BBlue}$3${Color_Off}"
		PROFILES=$3
		CONTAINER=$4
  fi

  # Create temporal files for ssh configuration.
  if [[ "$1" == "up -d" ]]; then

    # We need to create empty files since docker will try to
    # create dirs instead files. It's a known bug.
    touch .id
    touch .ssh_config

    # temporal file with ssh id_rsa.
    if [[ -f "$ID_RSA" ]]; then
        cat "$ID_RSA" > .id
    fi

    # temporal file with ssh config.
    if [[ -f "$SSH_CONFIG" ]]; then
        cat "$SSH_CONFIG" > .ssh_config
    fi

    ARGS_END="--remove-orphans"
  fi

  # Load docker-compose override
  ARGS="-f $PWD/docker-compose.yml -f $PWD/docker-compose.override.yml"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$1" == "up -d" ]]; then
        ARGS="${ARGS} -f $PWD/docker-compose.override.mac.yml"
        docker-sync start
    elif [[ "$1" == "stop" ]]; then
        docker-sync stop
    fi
  fi

  # Loads additional docker compose files defined in .docker.env
  if [ ! -z "$CUSTOM_DOCKER_COMPOSE" ]; then
    echo -e "Detected custom docker compose: ${BGreen}$CUSTOM_DOCKER_COMPOSE${Color_Off}"
    added_docker_compose=(${CUSTOM_DOCKER_COMPOSE})
    for new_docker_compose in "${added_docker_compose[@]}"
    do
        ARGS+=" -f $PWD/${new_docker_compose}"
    done
  fi

	# If we have profiles
  if [ ! -z "$PROFILES" ]; then
    echo -e "Active profiles: ${BGreen}$PROFILES${Color_Off}"
    # Split profiles by comma into an array
    IFS=',' read -ra PROFILES <<< "$PROFILES"
    for i in "${PROFILES[@]}"; do
      ARGS="${ARGS} --profile ${i}"
    done

    if [[ " ${PROFILES[*]} " =~ " php " ]]; then
      echo -e "Running with XDEBUG ${BGreen}$PHP_DEBUG_MODE${Color_Off}";
    fi
  fi

	echo "docker compose ${ARGS} $1 $CONTAINER ${ARGS_END}"
  docker compose ${ARGS} $1 $CONTAINER ${ARGS_END}

  # Remove temporal files
  if [[ -f .id ]]; then
    rm -rf .id
  fi

  if [[ -f .ssh_config ]]; then
    rm -rf .ssh_config
  fi

  # Return to previous dir
  cd $BACKDIR > /dev/null
}

# run docker-compose commands on traefik service.
_traefik_service() {
  docker compose -f /usr/local/bin/dk_traefik/docker-compose.yml $1
}

# run docker-compose commands on traefik service.
_track_dockerized_project() {
  touch ~/.dockerizer_track

  if grep -Fxq "$PWD" ~/.dockerizer_track
  then
    echo "This path is already tracked."
  else
    echo $PWD >> ~/.dockerizer_track
  fi
}

# Display dk help.
_show_help() {
   echo "dockerizer is a docker development tool that allows you to run dockerized LAMP projects."
   echo
   echo "Github project: https://frontid.github.io/dockerizer/"
   echo
   echo "Syntax: dk [command]"
   echo
   echo "Commands:"
   echo "new [dirname]   Creates an instance of dockerizer for a new project which will be located at dirname."
   echo "start [traefik]  When calling it in a project folder, it starts docker containers. You can start specific containers by adding them last, including traefik. If you add 'traefik' start the traefik service."
   echo "stop [traefik]   When calling it in a project folder, it stops docker containers. You can stop specific containers by adding them last, including traefik. If you add 'traefik' stop the traefik service."
   echo "down             When calling it in a project folder, it stops and removes containers, networks, images, and volumes."
   echo "xdebug [on/off]  Activates/Deactivates the xdebug for the PHP container."
   echo "setenv           Allows custom settings to be added for the current dockerized project. Settings like ID_RSA / SSH_CONFIG."
   echo "self-update      If there is a new version of the dk tool you can easily upgrade it with this command. It supports two parameters"
   echo "help             Shows this help."
   echo
   echo "Direct commands: (without dk prefix)"
   echo -e "Add parameter ${BGreen}--dkhelp${Color_Off} option to see the help section."

   # List direct commands available.
   _go_home_dir
   for filename in bin/*; do
     baseFileName=$(basename "$filename")
     firstCharacter=${baseFileName:0:1}
     if [[ $firstCharacter != "_" ]]; then
       echo -e "\t- $(basename $filename)"
     fi
   done
}

# Parses all arguments to be used as named arguments
# Exampled obtained from:
# https://www.drupal.org/node/244924#script-based-on-guidelines-given-above
# More about this: https://unix.stackexchange.com/questions/129391/passing-named-arguments-to-shell-scripts
_parse_arguments() {
  # Parse Command Line Arguments
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --branch=*)
        BRANCH="${1#*=}"
        ;;
      --propagate_update=*)
        PROPAGATE_UPDATE="${1#*=}"
        ;;
#      --help) _show_help;;
      *)
#        printf "************************************************************\n"
#        printf "* Error: Invalid argument, run --help for valid arguments. *\n"
#        printf "************************************************************\n"
#        exit 1
    esac
    shift
  done
}

# -----------------------------------------------
# Run main process

# Parse named arguments
_parse_arguments "$@"

# Temporal solution to add pre-existing projects to the config file.
if [ ! -z "$1" ] && [ $1 = "track" ] && [ -z "$2" ] ; then
    _track_dockerized_project

# Logs
elif [ ! -z "$1" ] && [ $1 = "logs" ]; then
    _docker_project "logs $2"

# Start project?
elif [ ! -z "$1" ] && [ $1 = "start" ] ; then
	# Do we have more parameters?
	if [ ! -z "$2" ] ; then
		
		if [ $2 = "traefik" ]; then
			# Start traefik
			_traefik_service "up -d"
		elif [ $2 = "profiles" ] ; then
		  # dk start profiles apache,mysql,etc
			if [ ! -z "$3" ] ; then
				_docker_project "up -d" $2 $3 $4
			else
				echo -e "Missing profiles specification. Use ${BBlue}dk start profiles apache,mysql${Color_Off}"
			fi
		else
		  # dk start apache
			_docker_project "up -d" $2 $3 $4
		fi
	else
		# Simply start all
		_docker_project "up -d"
	fi
# Stop project?
elif [ ! -z "$1" ] && [ $1 = "stop" ] ; then
	# Do we have more parameters?
	if [ ! -z "$2" ] ; then
		if [ $2 = "traefik" ]; then
			# Start traefik
			_traefik_service "stop"
		elif [ $2 = "profiles" ] ; then
			if [ ! -z "$3" ] ; then
				_docker_project "stop" $2 $3 $4
			else
				echo -e "Missing profiles specification. Use ${BBlue}dk stop profiles apache,mysql${Color_Off}"
			fi
		else
			_docker_project "stop" $2 $3 $4
		fi
	else
		# Simply stop all
		_docker_project "stop"
	fi
# Stop and remove containers, networks, images, and volumes?
elif [ ! -z "$1" ] && [ $1 = "down" ] ; then
    _docker_project "down" $2 $3
elif [ ! -z "$1" ] && [ $1 = "xdebug" ] && [ -z "$2" ]; then
    update_local_env PHP_DEBUG 1
    update_local_env PHP_DEBUG_MODE debug
    _docker_project "up -d" "php"
elif [ ! -z "$1" ] && [ $1 = "xdebug" ] && [ ! -z "$2" ]  && [ $2 = 'off' ]; then
    update_local_env PHP_DEBUG 0
    update_local_env PHP_DEBUG_MODE off
    _docker_project "up -d" "php"
elif [ ! -z "$1" ] && [ $1 = "setenv" ] && [ ! -z "$2" ]  && [ ! -z "$3" ]; then
  _load_env_variables
	echo -e "Previous value of ${BBlue}$2${Color_Off}: ${BRed}${!2}${Color_Off}"
  update_local_env $2 $3
  _load_env_variables
  echo -e "New value of ${BBlue}$2${Color_Off}: ${BRed}${!2}${Color_Off}"
# Restart project?
elif [ ! -z "$1" ] && [ $1 = "restart" ] && [ -z "$2" ]; then
    # We dont use just "restart" because this: If you make changes to your docker-compose.yml
    # configuration these changes are not reflected after running this command.
    _docker_project "stop"
    _docker_project "up -d"
# Restart project specific
elif [ ! -z "$1" ] && [ $1 = "restart" ]; then
    _docker_project "stop $2 $3 $4"
    _docker_project "start $2 $3 $4"

# Add new dockerizer
elif [ ! -z "$1" ] && [ $1 = "new" ] && [ ! -z "$2" ]; then
    git clone https://github.com/frontid/dockerizer.git $2
    cd $2
    ./setup.sh
    _track_dockerized_project

# Self update dockerizer
elif [ ! -z "$1" ] && [ $1 = "self-update" ]; then
  BRANCH=${BRANCH:-'master'} # --branch=[branch] Updates DK from a specific branch
  PROPAGATE_UPDATE=${PROPAGATE_UPDATE:-'on'} # --propagate_update=[on/off] Update all dockerized projects with this branch

  echo "Cleaning /tmp/dockerizer"
  echo "------------------------"

  rm -rf /tmp/dockerizer

  echo -e "Getting a new version of dockerizer [${BBlue}$BRANCH${Color_Off}]"
  git clone -b $BRANCH git@github.com:frontid/dockerizer.git /tmp/dockerizer

  # Before moving to a new directory save where we are
  BACKDIR=${OLDPWD:--}
  cd /tmp/dockerizer/setup_files > /dev/null

  # We need to update this same script, so it can be executed twice fixing possible errors during update.
  chmod +x *.sh
  sudo cp dockerizer_cli.sh /usr/local/bin/dk

  ./dockerizer_update.sh "$@"

  # Return to previous dir
  cd $BACKDIR > /dev/null

elif [ ! -z "$1" ] && [ $1 = "help" ]; then
  _show_help
else
  _show_help
  echo
  echo -e "\nCommand not found: ${BRed}$1 $2 $3 $4${Color_Off}"
fi
