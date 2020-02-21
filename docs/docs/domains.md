#Globally available domains
- `traefik.localhost`-> Traefik UI. Shows you all registered domains for all running projects under dockerizer.
- `portainer.localhost`-> Docker UI. Gives you an overview of all dockerizer projects and manage them.

[![](img/portainer.png)](img/portainer.png)

#Available domains by project
Each project will have the following domains (if you configured PROJECT_NAME as "foo"):  
- `foo.localhost` -> Website  
- `foo.pma.localhost` -> PhpMyAdmin  
- `foo.mailhog.localhost`-> MailHog client.
