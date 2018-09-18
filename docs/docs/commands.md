# Commands
Thanks to smartcd (installed when you ran install.sh) you can run common command inside the containers in a transparent way. It is possible because there is a "bin" dir with scripts with the same name of the real ones. These scripts just redirect the command into the right container.

Currently there're the following common commands:

##bower

Accepts all common software params. 

---

##bundle

Accepts all common software params.

---

##compass

Accepts all common software params.

---

##composer

Accepts all common software params.

---

##drush

Accepts all common software params.

---

##drupal (drupal console)

Accepts all common software params.

---

##gem

Accepts all common software params.

---

##grunt

Accepts all common software params.

---

##gulp

Accepts all common software params.

---

##node

Accepts all common software params.

---

##npm

Accepts all common software params.

---

##yarn

Accepts all common software params.

---

##logs
`logs` shows the logs of all containers or of a specific one. This command can be run anywhere inside the dockerized dir and project.

The available options are:  
`-f` Follow log output.

**Usage**  
Show logs of all containers: `logs`  
Show logs of an specific container: `logs apache`, `logs php`, `logs masriadb`  
Show logs of an specific container with the follow option set: `logs -f apache`

---

##cmd
`cmd` allows you to run arbitrary commands like `ls`, `tail` inside the **container**. Use this command when there is no an alias (see "common commands").  

**Usage**  
`cmd php ls -l` where "php" is the container and "ls -l" is the sent command.

---

##expose 
`expose` (Drops a container shell).  
By default connects to the php container if you do not specify any other. But if you want to connect to another container like the DB one just type `expose mariadb`.  
If you want to enter as **root** just add `--root`: `expose apache --root`.

**Available containers are:** 

- php (by default)
- mariadb (mysql)
- apache
- frontend


**Usage**  
`expose` drops a shell of php (default)  
`expose apache` drops a shell of apache  
`expose apache --root` drops a root shell of apache

---

#Adding new command
To create a new "command" like "drush" does just create a new empty file at ./bin dir and fill with this code:

```
#!/bin/bash
source _command_wrapper '[CONTAINER NAME]' 'exec' '[COMMAND]' $@
```
CONTAINER NAME: The container where the command resides.
COMMAND: the command to be run. 

And that's all. Now you will be able to run the command locally as any other command and it will be pushed into the right container and run into it. 
