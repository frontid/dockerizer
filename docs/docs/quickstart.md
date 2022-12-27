## Installing your pet project quickly

You might want to start up a new site quickly so here are the steps:

1. dk new mysite
2. cd mysite
3. mkdir web 
4. cp example.docker.env web/.docker.env
5. dk start

Now you can install the codebase of your choice Drupal, Laravel, Symfony, Wordpress...

If you choose for Drupal you can run:

1. composer create-project drupal/recommended-project web                                        # Drupal latest version in web folder
2. cd web && drush si --db-url=mysql://db:db@dockerizer_mariadb:3306/db --account-pass=admin -y  # Install Drupal
3. update .docker.env to point PROJECT_BASE_PATH=web


