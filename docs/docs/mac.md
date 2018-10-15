# Requirements

```
brew install docker-sync
brew install unision
brew install ugenmayer/dockersync/unox
brew install bash
```

Brew  ([Homebrew](http://brew.sh/)) is a tool you need under OSX to install / easy compile other tools.

# Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/frontid/dockerizer/mac-support/install.sh)
dk start traefik
```

# Configure a new project
Dockerizer works on a high level of your project and the first step is to clone it on your projects dir:

```bash
dk new myproject_dockerized
cd myproject_dockerized
git checkout mac-support
git clone git@github.com:YOU/YOUR-PROJECT.git web
```

Next you need "dockerize" a project. To accomplish that the only thing you need to do is  create `.docker.env` and commit the preferences on the file.  
Dockerizer provides you an example. Copy `example.docker.env` as `.docker.env` at your "web" dir and configure it (See **[.docker.env](/dockerenv)** documentation for a more detailed explanation). 

That's all, now run `docker-sync start` and `dk start` and happy coding!

# Run a configured project
If your project already has `.docker.env` pushed on your project follow these steps.

```bash
dk new myproject_dockerized
cd myproject_dockerized
git checkout mac-support
git clone git@github.com:YOU/YOUR-PROJECT.git web
docker-sync start
dk start
```

# Debug

For debugging it's necessary add the server into phpstorm. When you active the debugger, you can see a message like this:

    Can't find a source position. Server with name 'drupal.localhost' doesn't exist.

So, you need to add a server with the same name (drupal.localhost in this case).

Also, you need to configure a map folder into phpstorm, for this, you need to check **Use path mappings** option and configure the root folder to **/var/www/html/web**.