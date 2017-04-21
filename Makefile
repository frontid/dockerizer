# This Makefile is aimed to help start quickly preparing a development sandbox to run drupal under docker4drupal 
# transparently.
#
# Make sure an html folder exists in the root folder before running the create task
#
# It is recommended to install smartcd (https://github.com/cxreg/smartcd) for this purpose.
# Check README for usage

# Drupal project name used to create the URLs for the project (NAME.docker.localhost:8000)
NAME=drupal
export NAME

# The site will need to be running under the NAME specified by parameter. 
# Modify the docker-compose so the new url will look like NAME.docker.localhost:8000
prepare-docker:
	sed -i 's/Host:\(.*\)drupal/Host:\1$(NAME)/g' docker/docker-compose.yml && \
		sed -i 's/projectname/$(NAME)/g' docker/docker-compose.yml && \ 
		sed -i 's/projectname/$(NAME)/g' docker/.env && \ 

# Prepare the docker installation with the boilerplate branch
clone-docker:
	@echo "Creating docker repo" && \
        git clone git@github.com:nicobot/docker4drupal.git --branch boilerplate --single-branch docker

# Storage folder will save the mysql data
# mariadb-init will store dump files
create-storage:
	mkdir storage && mkdir mariadb-init

# Bring up docker
bring-up-docker:
	./bin/dc up -d

# It will create a user (ext-user) inside docker with the same ID. This will allow us to run any command with the same user
# It will also add the www-data user to the ext-user group, so www-data will be able to access its group files
create-mapped-user:
	./bin/dockersudo adduser -D -u `id -u` ext-user && \
		./bin/dockersudo ./bin/add-dependencies && \
		./bin/dockersudo usermod -a -G www-data ext-user

prepare-smartcd-if-available:
	if [ -f ~/.smartcd_config ]; then echo "autostash PATH=$(PWD)/bin:\$$PATH" | ~/.smartcd/bin/smartcd edit enter; fi

# Changing directory will trigger smartcd to load new PATH
change-dir:
	cd .

create: prepare-smartcd-if-available change-dir clone-docker prepare-docker create-storage bring-up-docker create-mapped-user

mount-drupal-project:
	git clone git@github.com:nicobot/drupal-project.git --branch master --single-branch drupal && \
		ln -s drupal/web html
