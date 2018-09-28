#!/usr/bin/env bash

# @todo remove traefik container and image.
rm -rf .smartcd .smartcd_config
sudo rm -rf /usr/local/bin/dk_traefik
sudo rm /usr/local/bin/dk
sudo rm /etc/bash_completion.d/dk