## "dk" the dockerizer cli
Dockerizer uses a very simple tool to manage the projects. 

This tool manages two aspects of the dockerized projects. The project itself and the global proxy (traefik).

## dk on projects
When you have a configured "dockerized" project you will want to start, stop, and restart it right?  
Well. Just go to the project and run `dk start|stop|restart`.
 
## dk on proxy
And what if you want to stop the proxy to release the 80 and 443 ports?  
Well, run `dk stop|start traefik` :) (no matter the current path you are on).
