# Dockerizer

Dockerizador es un entorno de desarrollo basado en docker enforcado a aplicaciones LAMP proncipalmente.

Features:
- Usa un proxy central (traefik) y arrancha al inicio del SO.
- El wizard genera un archivo de conf que se puede comitear en el proyecto. Luego el dockerizador lo reconoce y puede montar el docker en nuevos ordenadores (util para compartir una configuración unica para todos los que trabajan sobre un proyecto).
- Bind de comandos desde el host*: Lanza comando dentro de los contenedores de forma transparente gracias a los comandos que proporciona el dockerizador. (ver directorio bin/)
- Acceso rapido a contenedores mediante el comando "*expose*"
El bind de un comando realmente es solo un wrapper que reenvía un comando desde el host al contenedor que corresponda. Por ejemplo al hacer "drush cr", el dockerizador abre una conexion al contenedor "php" y le envía ese comando.


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

And these command are available too:
- `dc` (alias of docker-compose)
- `expose` (makes ssh to a container). By default connects to the php container if you do not specify any other. But if you want to connect to another container like the DB one just type `expose mariadb`.
Available containers are: php (by default), mariadb, apache2, nginx, frontend, mailhog, pma.
...


Pendientes:
Soporte para mac (estaba en el dc original)
Añadir los contenedorers extras que tiene el proyecto original
la version minima de docker ahora es 18.03
aplicar las evoluciones y fixes que se fueron haciendo en la rama master.
el setup.sh lo elimine pero lo necesitamos como minimo para que cree la red interna de traefik y àra que lo instale. Adicionalmente que añada un par de alias en los binarios del sistema para parar y arrancar el dockerizer traefik.
revisar documentación
recuperar las claves ssh
el comando drupal no creo que funcione. debería mirar dentro de vendors pero el script no esta configurado para tal cosa.