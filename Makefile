# Drupal project name
NAME=drupal
export NAME

prepare-docker:
	sed -Ei 's/Host:\(.*\.)drupal/Host:\1$(NAME)/g' docker/docker-compose.yml

clone-docker:
	@echo "Creating docker repo" && \
        git clone git@github.com:nicobot/docker4drupal.git --branch boilerplate --single-branch docker

create-storage:
	mkdir storage

create: clone-docker prepare-docker create-storage 
