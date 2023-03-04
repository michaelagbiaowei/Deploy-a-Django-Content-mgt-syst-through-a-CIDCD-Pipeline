# USING BASH SCRIPT TO INSTALL DOCKER ENGINE

#!/usr/bin/env bash

# Step 1:
# This example downloads the script from https://get.docker.com/ and runs it to install the latest stable release of Docker on Linux:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Step 2:
# Test the installation
docker -v