# Mac support

Change you current branch to **mac-support**.

## Install docker-sync and unision 

```sh
 brew install docker-sync
 brew install unison
 brew install eugenmayer/dockersync/unox
``` 

Brew  ([Homebrew](http://brew.sh/)) is a tool you need under OSX to install / easy compile other tools.

## Debug

For debugging it's necessary add the server into phpstorm. When you active the debugger, you can see a message like this:

    Can't find a source position. Server with name 'drupal.localhost' doesn't exist.

So, you need to add a server with the same name (drupal.localhost in this case).

Also, you need to configure a map folder into phpstorm, for this, you need to check **Use path mappings** option and configure the root folder to **/var/www/html/web**.