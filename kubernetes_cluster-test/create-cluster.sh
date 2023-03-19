# USING BASH SCRIPT TO CREATE KUBERNETES CLUSTERS

#!/usr/bin/env bash

# Step 1:
# Create the deployment-service cluster
kubectl apply -f django-deployment-files/app-deploy.yml
kubectl apply -f django-deployment-files/app-service.yml

# Step 2:
# # Create the database-service cluster
kubectl apply -f postgres-deployment-files/ConfigMap.yml
kubectl apply -f postgres-deployment-files/postgres-deploy.yml
kubectl apply -f postgres-deployment-files/PersistentVolumeClaim.yml
kubectl apply -f postgres-deployment-files/postgres-service.yml

