## "dk" the dockerizer cli
Dockerizer uses a very simple tool to manage the projects. 

## dk new
This command will prepare a dockerizer dir for you. For example if you run `dk new foo` it will create `foo` dir with the dockerizer structure ready to use. So the only thing you need to do is create web dir as mentioned at [Configure a new project](/install) on the Install section. 

## dk on projects
When you have a configured "dockerized" project you will want to start, stop, and restart it right?  
Well. Just go to the project and run `dk start|stop|restart`.
 
## dk on proxy
And what if you want to stop the proxy to release the 80 and 443 ports?  
Well, run `dk stop|start traefik` :) (no matter the current path you are on).
 
## dk self-update
If there is a new version of the dk tool you can easily upgrade it with this command.
