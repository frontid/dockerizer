# Requirements

```bash
brew install docker-sync
brew install unision
brew install ugenmayer/dockersync/unox
brew install bash
```

Brew  ([Homebrew](http://brew.sh/)) is a tool you need under OSX to install / easy compile other tools.

# Config

You should change the image for php container. So, you should create at your `web` directory a file called `.docker.override.env` with the follow contain:

```yml
PHP_TAG=7.2-dev-macos-4.8.0
```

That's all, now run `dk start` and happy coding!

# Debug

For debugging it's necessary add the server into phpstorm. When you active the debugger, you can see a message like this:

    Can't find a source position. Server with name 'my-ide' doesn't exist.

So, you need to add a server called `my-ide`.

Also, you need to configure a map folder into phpstorm, for this, you need to check **Use path mappings** option and configure the root folder to **/var/www/html/web**.