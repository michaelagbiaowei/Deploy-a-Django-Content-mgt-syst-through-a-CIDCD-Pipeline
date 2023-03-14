# USING BASH SCRIPT TO START A KUBERNETES DEPLOYMENT
# NOTE:: THIS SCRIPT REQUIRES TO BE ECXECUTED TWICE IN AN INTERVAL OF APPROXIMATELY 3 MINUTES

#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=maiempire/django_project-app

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run django_project-app \
	--image=$dockerpath \
	--port=80 

# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
kubectl port-forward django_project-app 8000:80
