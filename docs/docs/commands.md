## Commands
Thanks to smartcd (installed when you ran install.sh) you can run common command inside the containers in a transparent way. It is possible because there is a "bin" dir with scripts with the same name of the real ones. These scripts just redirect the command into the right container.

Currently there're the following common commands:
- `bower`
- `bundle`
- `compass`
- `composer`
- `drush`
- `drupal` (drupal console)
- `gem`
- `grunt`
- `gulp`
- `node`
- `npm`
- `yarn`

And these command are available too:
- `cmd` Allows you to run arbitrary commands like `ls`, `tail` etc. Use this command when there is no an alias (see "common commands"). Usage `cmd php drush ws --tail` where "php" is the container and "drush ws --tail" is the sent command. 
- `expose` (makes ssh to a container). By default connects to the php container if you do not specify any other. But if you want to connect to another container like the DB one just type `expose mariadb`. If you want to enter as root just add `--root`: `expose apache --root`.

Available containers are: php (by default), mariadb, apache, frontend, mailhog, pma.

## Adding new commands
to create a new "command" like "drush" doews just create a new empty file at ./bin dir and fill with this core:

```
#!/bin/bash
source _command_wrapper '[CONTAINER NAME]' 'exec' '[COMMAND]' $@
```
CONTAINER NAME: The container where the command resides.
COMMAND: the command to be run. 

And that's all. Now you will be able to run the command locally as any other command and it will be pushed into the right container and run into it. 
