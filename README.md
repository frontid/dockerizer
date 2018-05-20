# Dockerizer

Dockerizador es un programa que permite generar un docker-compose.yml y algunos bindings de aplicaciones comunes para ejecutarlas desde el host.

Features:
- Usa un proxy central (traefik) y arrancha al inicio del SO.
- Tiene un wizard para instalaciones iniciales para seleccionar versión de PHP, Mysql, Apache o nginx, etc.
- El wizard genera un archivo de conf que se puede comitear en el proyecto. Luego el dockerizador lo reconoce y puede montar el docker en nuevos ordenadores (util para compartir una configuración unica para todos los que trabajan sobre un proyecto).
- Bind de comandos desde el host*: Lanza comando dentro de los contenedores de forma transparente gracias a los comandos que proporciona el dockerizador. (ver directorio bin/)
- Acceso rapido a contenedores mediante el comando "*expose*"
El bind de un comando realmente es solo un wrapper que reenvía un comando desde el host al contenedor que corresponda. Por ejemplo al hacer "drush cr", el dockerizador abre una conexion al contenedor "php" y le envía ese comando.


## Install
After clonning this project you should run `./setup.sh`. This command starts a wizard that will help you to configure your environment.

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
Implementar el override para modificar cosas extra como los labels de traefik o añadir la red a la que pertenecen los contenedores.
la version minima de docker ahora es 18.03