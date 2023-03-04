# USING BASH SCRIPT TO CREATE KUBERNETES CLUSTER

#!/usr/bin/env bash

# Step 1:
# Create the database-service cluster
kubectl apply -f postgres/service.yaml 

# Step 2:
# Create the deployment-service cluster
kubectl apply -f django_project-app/deployment.yaml