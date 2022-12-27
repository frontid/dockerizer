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

# Display dk help.
_show_help() {
   echo "dockerizer_update is a tool for updating the current dockerizer project and each instance."
   echo
   echo "Github project: https://frontid.github.io/dockerizer/"
   echo
   echo "Syntax: dk self-update [OPTIONS]"
   echo
   echo "OPTIONS:"
   echo -e "${BBlue}--branch${Color_Off}            Updates the dockerizer from a specific branch (release/tag)."
   echo -e "${BBlue}--propagate_update${Color_Off}  Updates all the instances of the dockerizer to the specified branch. Values accepted [on|off]"
   echo -e "${BBlue}--help${Color_Off}              Shows this help."
   echo

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
      --help)
        _show_help
        exit 0
        ;;
      *)
#        printf "************************************************************\n"
#        printf "* Error: Invalid argument, run --help for valid arguments. *\n"
#        printf "************************************************************\n"
#        exit 1
    esac
    shift
  done
}

# Main process -------------------------------------------------------------------

_parse_arguments "$@"

PROPAGATE_UPDATE=${PROPAGATE_UPDATE:-'on'} # Update all dockerized projects with this branch

dk stop traefik

echo "------------------------"
echo "Updating..."
echo "------------------------"

sudo cp dockerizer_cli.sh /usr/local/bin/dk
sudo cp dockerizer_cli_bash_autocomplete /etc/bash_completion.d/dk
sudo chmod +x /usr/local/bin/dk

# ------------------------------

traefik_path="/usr/local/bin/dk_traefik"
sudo cp traefik-docker-compose.yml "$traefik_path/docker-compose.yml"
sudo cp -R traefik $traefik_path

# ------------------------------
if [ $PROPAGATE_UPDATE = 'on' ]; then
  echo "Updating all dockerized instances."
  echo ""

  # Just to prevent errors.
  touch ~/.dockerizer_track

  while read path; do
      if [[ -d "$path" ]]; then
        cd "$path"
        echo "Updating $path"
        git reset --hard > /dev/null
        git pull origin master
        echo ""
      fi
  done <~/.dockerizer_track
else
  echo "Skipped updates on all dockerized instances."
  echo ""
fi
dk start traefik
echo "Done."
