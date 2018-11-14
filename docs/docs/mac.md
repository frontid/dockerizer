Dockerizer is compatible with mac and out of the box will be **almost** ready to use.  

"**Almost**" means that you will need to do a small override since **Mac has it own PHP container**. 

Normally on a new or an existent project you will need a `.docker.env` file configured for your project (See [install page](install) instructions) and this file will contain the PHP container the project will use and normally will be a linux version.
  
If all your team is using linux it is ok, but **if your team uses mainly Mac** then you can select a mac container as a default PHP container (See [.docker.env file options](dockerenv) for more references).

On the other hand, **If your team uses linux and you need a mac container for your local development**, the way to use a mac version only at your localhost is via `.docker.override.env` (See [.docker.env file options](dockerenv) for more references).
