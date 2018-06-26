# Installation
To install dockerizer run:
```bash
git clone git@github.com:frontid/dockerizer.git dockerizer_install
cd dockerizer_install
chmod +x install.sh
sudo -s ./install.sh
cd ..
rm -rf dockerizer_install
```

# Configure a new project
Dockerizer works on a high level of your project and the first step is to clone it on your projects dir:

```bash
git clone git@github.com:frontid/dockerizer.git myproject_dockerized
cd myproject_dockerized
chmod +x setup.sh
./setup.sh
```

At this point you need to create "web" dir (`myproject_dockerized/web`) and clone your project there.  
 

Next you need "dockerize" a project. To accomplish that the only thing you need to do is  create `.docker.env` and commit the preferences on the file.  
Dockerizer provides you an example. Copy `example.docker.env` as `.docker.env`. 

The file has things like the PHP and Mysql versions, ssh credentials path, etc. Please configure the options you need for this project and commit the file.(See **[.docker.env](dockerenv)** documentation for a more detailed explanation).

That's all, now run `dk start` and start coding!

# Run a configured project
If your project already has `.docker.env` pushed on your project follow these steps.

Go to your projects dir and:

```bash
git clone git@github.com:frontid/dockerizer.git myproject_dockerized
cd myproject_dockerized
chmod +x setup.sh
./setup.sh
```

At this point you need to create "web" dir (`myproject_dockerized/web`) and clone your project there. (Remember, at this point you must have a configured `.docker.env` on your project dir [`web/docker.env`])  
Then you are ready to start your dockerizer  

```bash
dk start
```

