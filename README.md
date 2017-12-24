# drupal-project-boilerplate

This project is aimed to help start quickly preparing a development sandbox to run drupal under docker seemlessly.

After clonning this project you should:

1. Run: ./setup.sh
 This command starts a wizard that will help you to configure your environment.

Then you're ready to develop!

Thanks to smartcd (installed when you ran serup.sh) you can run common command inside the containers in a transparent way. It is possible because there is a "bin" dir with scripts with the same name of the real ones. These scripts just redirect the command into the right container.

Currently there're the following common commands:
- `bower`
- `bundle`
- `compass`
- `composer`
- `dll` [PLEASE EXPLAIN THIS COMMAND]
- `drush`
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
