# docker.env file

| VAR                 | MEANING                                    | |
|---------------------|--------------------------------------------|--------------------------------------------------------------------------------------------|
| PROJECT_NAME        | The project base name                      | Needs to be customized                                                                     |
| PROJECT_BASE_URL    | The project url                            | Needs to be customized                                                                     |
| SSH_CREDENTIALS     | The location of your ssh agent credentials | On most cases the default value is enough                                                  |
| DOCKER_PROJECT_HOST | IP of the docker host                      | In order to xdebug you need the right docker host ip. Normally is 172.17.0.1 or 172.17.0.2 |
| PROJECT_BASE_PATH   | Base project's path                        | If your project resides in a subdir you can specify it on PROJECT_BASE_PATH                |


For the rest of available variables please see  [https://github.com/wodby/docker4drupal](https://github.com/wodby/docker4drupal)