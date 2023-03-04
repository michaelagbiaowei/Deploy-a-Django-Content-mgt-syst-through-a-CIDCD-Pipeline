# USING BASH TO INSTALL DOCKER-COMPOSER

#!/usr/bin/env bash

# Step 1:
# Download the installation script
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

# Step 2:
# Apply executable permissions to the binar
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Step 3:
# Test the installation
docker compose version
