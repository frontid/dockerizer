# .docker.env file

This is the shared docker configuration file. On it you can configure things like PHP version, MySQL version, PHP, settings an all you need to fit the project into the docker.

| VAR                      | MEANING                                    | |
|--------------------------|--------------------------------------------|--------------------------------------------------------------------------------------------|
| PROJECT_NAME             | The project base name                      | Needs to be customized                                                                     |
| PROJECT_BASE_URL         | The project url                            | Needs to be customized                                                                     |
| PROJECT_BASE_PATH        | Base project's path                        | If your project resides in a subdir you can specify it on PROJECT_BASE_PATH                |
| PHP_MAX_EXECUTION_TIME   | PHP max execution time                     | |
| PHP_POST_MAX_SIZE        | PHP max $_POST size                        | |
| PHP_UPLOAD_MAX_FILESIZE  | PHP max $_POST file size                   | |
| PHP_MEMORY_LIMIT         | PHP apache memory limit (cli is unlimited) | |
| PHP_TAG                  | Sets the php container/version to be used. | For **linux and mac there are two group of possible values**. *"7.1-dev-4.8.0"* format for linux and *"7.2-dev-macos-4.8.0"* for mac.|

For the rest of available variables please see  [https://github.com/wodby/docker4drupal](https://github.com/wodby/docker4drupal)

Since `.docker.env` is a common shared file you will not be able to make personal modifications on it. For this king of customizations you have `.docker.override.env`  

`.docker.override.env` should be never committed since it is only for you and your environment. The usage is really simple. Just put in there the variables you want to override with the new value like in the original `.docker.env` file.