# create a repository to store the docker image in docker hub
# launch an ec2 instance. open port 80 and port 22

#!/bin/bash

# Update package list and upgrade installed packages
sudo apt update -y
sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# (Optional) Add user to docker group
# sudo usermod -aG docker $USER

# Build Docker image from Dockerfile
sudo docker build -t latest .

# Login to Docker Hub
cat ~/my_password.txt | sudo docker login --username dockerhub --password-stdin

# Tag the built Docker image with a new name
sudo docker tag latest dockerhub/my-docker-image

# Push the tagged image to Docker Hub
sudo docker push dockerhub/my-docker-image

# Start a container to test the image 
sudo docker run -dp 80:80 dockerhub/my-docker-image
