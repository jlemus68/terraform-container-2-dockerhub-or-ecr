#!/bin/bash

# Update packages and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y

# Start Docker service
sudo service docker start
sudo systemctl enable docker

# Add the current user to the docker group and restart Docker
sudo usermod -aG docker ec2-user
sudo systemctl restart docker

# Check Docker info
docker info

# Build the Docker image
sudo docker build -t test .

# Authenticate Docker to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com

# Build the Docker image
docker build -t test .

# Tag the Docker image
docker tag test:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/test:latest

# Push the Docker image to ECR
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/test:latest

# Start the container to test the image
sudo docker run -dp 80:80 123456789012.dkr.ecr.us-east-1.amazonaws.com/test:latest

# references
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html
# https://docs.docker.com/get-started/02_our_app/