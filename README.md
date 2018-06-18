# Dockerizer
Dockerizador es un entorno de desarrollo basado en docker enforcado a aplicaciones LAMP principalmente.

Features:
- Usa un proxy central, traefik, que se autoinicia cuando el SO inicia.
- Solo necesitas confirgurar una vez el proyecto y comitear el archivo .env para que todos tengan el mismo entorno de desarrollo.
- Ejecuta comandos de forma transparente en los contenedores.
- Acceso rapido a contenedores mediante el comando "*expose*"

# Requirements
- Docker > 18.03

## Install
After clonning this project you should run `./setup.sh`. This command setup some needed tools around docker.


## Setup project
After cloning the dockerizer you unly need to fill your project preferences. Copy example.env to .env and change the variables you need.
Then you are ready to run `docker-compose up -d`

Then you're ready to develop!

## Usage
Thanks to smartcd (installed when you ran setup.sh) you can run common command inside the containers in a transparent way. It is possible because there is a "bin" dir with scripts with the same name of the real ones. These scripts just redirect the command into the right container.

Currently there're the following common commands:
- `bower`
- `bundle`
- `compass`
- `composer`
- `dll` (send an internal `ls -l`)
- `drush`
- `drupal` (drupal console)
- `gem`
- `grunt`
- `gulp`
- `node`
- `npm`
- `yarn`

And these command are available too:
- `dc` (alias of docker-compose)
- `expose` (makes ssh to a container). By default connects to the php container if you do not specify any other. But if you want to connect to another container like the DB one just type `expose mariadb`.
Available containers are: php (by default), mariadb, apache2, nginx, frontend, mailhog, pma.

## Adding new commands
to create a new "command" like "drush" doews just create a new empty file at ./bin dir and fill with this core:

```
#!/bin/bash
source _command_wrapper '[CONTAINER NAME]' 'exec' '[COMMAND]' $@
```
CONTAINER NAME: The container where the command resides.
COMMAND: the command to be run. 

And that's all. Now you will be able to run the command locally as any other command and it will be pushed into the right container and run into it. 
...

# Known issues
- smartcd trends to mess the dir where its on [docme]. 

# Estructura (para contribuidores)
El dockerizador es un paquete de 3 herramientas:
- SmartCD
- Docker
- Traefik

Al lanzar el instalador este instala traefik globalmente (en el dir ~/.local/share/traefik).  
Traekif se encarga de entender la URL y enviar la peticion al contenedor que toca.
Esto es especialmente util a medida que vayas añadiendo mas y mas webs dockerizadas en tu ordenador ya 
que no vas a tener que preocuparte de andar añadiendo nada a /etc/hosts ni jugar con los puertos.

Smartcd es el encargado de convertir comandos locales en comandos remotos. Esto lo logra escuchando el directorio de algun proyecto dockerizado. Cuando entras, smartcd "activa" todos los comandos que tengas definidos en el directorio "bin". Que a su vez, estos comandos lo unico que hacen es enviar el comando escrito localmente al contenedor internamente. 
De esta forma no tienes que estar usando comandos complejos para lanzar por ejemplo drush. Simplemente lanza "drush cc all" estando dentro del directorio dockerixado (o cualquier subdirectorio) y drush se ejecutará dentro del contenedor que haga falta.

La capa de docker está dicidida en 3 partes. 
1: docker-compose.yml que es la implementacion casi pura de https://github.com/wodby/docker4drupal y es la base de todo el dockerizador.
2: docker-compose.override.yml que es nuestra propia capa que modifica al docker-compose.yml y que usamos para añadir funcionalidad (o modificar parametros) al docker-compose.yml de docker4drupal.
3: .env Almacena todas las variables especificas del proyecto dockerizado como la URL, versiones de php, db, etc. 
