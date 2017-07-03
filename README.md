# drupal-project-boilerplate

This project is aimed to help start quickly preparing a development sandbox to run drupal under docker4drupal seemlessly.
It is recommended to install smartcd (https://github.com/cxreg/smartcd) for this purpose.

After clonning this project you should:

1- Run: make create NAME=<drupal_project>

2- You might want to add the drupal-project into it, then run:
		make mount-drupal-project

2 (bis)- If you already have a drupal project, clone it manually inside of the root folder, and only make sure, there's a folder (or link) called html that points to the web that will be served.

3- It's recommended to use the drupal-project template from pfressen, check: https://github.com/pfrenssen/drupal-project

Then you're ready to develop!

You can run commands inside the docker from your local OS, just as you were having everything installed.

Currently I have prepared the following common commands:
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
