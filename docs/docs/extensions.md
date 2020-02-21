# Extensions
There are multiple extensions that can be used but are not enabled by default, in this page we'll start documenting how to enable each extension.

# Blackfire
https://blackfire.io will help to measure times and memory of page loads and more. 
In order to enable it you need to:
- first you need to have a blackfire account. You'll need to grab from the account the Client ID, Client Token, Server ID and Server Token.
- uncomment from docker-compose.yml the `blackfire` container
- set the BLACKFIRE_SERVER_ID and BLACKFIRE_SERVER_TOKEN to the `blackfire` container in the docker-compose.yml
- uncomment from docker-compose.override.yml the `blackfire` container
- uncomment from docker-compose.override.yml, in the `php` container, the environment variables:
```bash
	PHP_BLACKFIRE: 1
    BLACKFIRE_CLIENT_ID: CLIENT_XXXXXX
    BLACKFIRE_CLIENT_TOKEN: CLIENT_YYYYY
    PHP_BLACKFIRE_AGENT_HOST: "${PROJECT_NAME}_blackfire"
```
- set variables BLACKFIRE_CLIENT_ID and BLACKFIRE_CLIENT_TOKEN
