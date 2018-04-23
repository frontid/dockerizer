#include ../_html/.env
set -o allexport
source ./html/.env
set +o allexport


# Creamos el archivo base sobre el que se van a appendear el resto de los fragmentos.
touch docker-compose.yml
cat docker-templates/docker-compose-base.yml > docker-compose.yml

envsubst < "docker-templates/service-mariadb.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-php.yml" >> "docker-compose.yml"

# Si se ha seleccionado apache
if [ -v APACHE_TAG ]; then
    envsubst < "docker-templates/service-apache.yml" >> "docker-compose.yml"
fi

# Si se ha seleccionado nginx
if [ -v NGINX_TAG ]; then
    envsubst < "docker-templates/service-nginx.yml" >> "docker-compose.yml"
fi

envsubst < "docker-templates/service-frontend.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-mailhog.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-pma.yml" >> "docker-compose.yml"
envsubst < "docker-templates/docker-compose-base-final.yml" >> "docker-compose.yml"
