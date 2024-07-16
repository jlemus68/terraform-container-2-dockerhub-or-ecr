# create a repository to store the docker image in docker hub
# launch an ec2 instance. open port 80 and port 22

#!/bin/bash

# install and configure docker on the ec2 instance
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
# sudo usermod -a -G docker ec2-user
docker info

# # create a dockerfile
# sudo vi Dockerfile 

# build the docker image
sudo docker build -t latest .

# login to your docker hub account
cat ~/my_password.txt | sudo docker login --username dockerhub --password-stdin

# use the docker tag command to give the image a new name
sudo docker tag latest dockerhub/my-docker-image

# push the image to your docker hub repository
sudo docker push dockerhub/my-docker-image

# start the container to test the image 
sudo docker run -dp 80:80 dockerhub/my-docker-image

# references
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html
# https://docs.docker.com/get-started/02_our_app/