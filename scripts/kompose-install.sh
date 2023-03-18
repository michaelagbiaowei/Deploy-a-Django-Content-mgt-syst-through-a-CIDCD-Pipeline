# USING BASH SCRIPT TO INSTALL KOMPOSE	

#!/usr/bin/env bash

# Step 1:
# Download the instalation for Linux
curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-linux-amd64 -o kompose

# Step 2:
# Privileges
chmod +x kompose

# Step3:
# Move binaries
sudo mv ./kompose /usr/local/bin/kompose

