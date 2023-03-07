# USING BASH SCRIPT TO CREATE KUBERNETES CLUSTER

#!/usr/bin/env bash

# Step 1:
# # Create the database-service cluster
# kubectl apply -f configmap.yml
# kubectl apply -f storage.yml
# # kubectl apply -f database.yml
# kubectl apply -f t.yml
# kubectl apply -f service.yml 
# # # kubectl apply -f postdb.yml
kubectl apply -f Deployment.app.db.yml
# Step 2:
# Create the deployment-service cluster
# kubectl apply -f django-app-deployment.yml
# I'm trying to deploy an application on Kubernetes.
