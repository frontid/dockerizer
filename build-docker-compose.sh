# Este archivo depende de las variables definidas en el script principal.

# Creamos el archivo base sobre el que se van a appendear el resto de los fragmentos.
touch docker-compose.yml
cat docker-templates/docker-compose-base.yml > docker-compose.yml

envsubst < "docker-templates/service-mariadb.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-php.yml" >> "docker-compose.yml"

# Si se ha seleccionado apache
if [ $webserver = "apache" ]; then
    envsubst < "docker-templates/service-apache.yml" >> "docker-compose.yml"
fi

# Si se ha seleccionado nginx
if [ $webserver = "nginx" ]; then
    envsubst < "docker-templates/service-nginx.yml" >> "docker-compose.yml"
fi


# Si ha seleccionado ambos
if [ $webserver = "both" ]; then
    envsubst < "docker-templates/service-apache.yml" >> "docker-compose.yml"
    envsubst < "docker-templates/service-nginx.yml" >> "docker-compose.yml"
fi


envsubst < "docker-templates/service-frontend.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-mailhog.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-pma.yml" >> "docker-compose.yml"
envsubst < "docker-templates/service-traefik.yml" >> "docker-compose.yml"