# drupal-project-boilerplate

This project is aimed to help start quickly preparing a development sandbox to run drupal under docker seemlessly.

After clonning this project you should:

1. Run: ./setup.sh
 This command starts a wizard that will help you to configure your environment.

Then you're ready to develop!

You can run commands inside the docker from your local OS, just as you were having everything installed.

Currently there're the following common commands:
- composer
- drush

So you can execute from your drupal folder:
composer install 
drush updb -y
drush cr
...

Please also note, that using pipes is not currently performing well so that functionality has been postponed.

If you'd like to run a command as sudo, then you should use the special command "dockersudo <my-command>"

You can also run any command using "expose <any-command>"

And last, you can also run docker-compose with the specific docker-compose.yml file, just using "dc", so try "dc ps" from where-ever you're. 

## TODOS
- Implement a configfile "docker4drupal.ini" or something similar to store the specific project configuration. This file will be putted into the html dir to allow it to be pushed to the project. Then when a user use drupal-project-boilerplate it would be able to detect the conf and ask to the user if it should use it (preconfirured projects).

