#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker-compose.sh`

# Step 1:
# Create dockerpath
dockerpath=django_project-app

# Step 2:  
# Authenticate & tag
# echo "Docker ID and Image: $dockerpath"
docker login -u maiempire

#Step 3:
# Tag the images with your Docker ID
docker tag $dockerpath:latest maiempire/$dockerpath

# Step 4:
# Push image to a docker repository
docker push maiempire/$dockerpath
