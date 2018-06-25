# Dockerizer
Dockerizer is a docker development tool that allows you to run dockerized LAMP projects. 

## Features
- A centralized proxy. It allows you to run many different projects all under the common **80** and **443** ports instead assigning a por for each project.
- Out of the box you have **https** enabled.
- Configure once and spread to the other collaborators. Commit `.docker.env` into your project with the required options and your colleagues will just run the same environment with just one command. 
- Forget about the fact that you are working with dockerized projects when run commands. Do you want use `gulp` or `drush` from your host machine but execute on the containers? No problem. Dockerizer has the ability to run commands seamlessly. Just run `gulp build` and that's it. 
