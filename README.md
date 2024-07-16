# Repo Description

---

This repository contains Terraform configurations to deploy resources on AWS EC2 instances or Azure VMs. These configurations automate the deployment process by:

1. Creating the instances.
2. Installing Docker.
3. Building and deploying the specified Docker image.
4. Deploying a Docker container.

After deployment, you can access the deployed website via the public IP or URL provided in the output. 

**Notes:**

- **Refactoring Needed:** The Terraform code can be improved by parameterizing various values for better flexibility and maintainability.
- **Sensitive Files:** Ensure sensitive files such as password files or PEM keys are stored securely. These should not be included in your codebase. Consider using AWS Secrets Manager or local storage.
- **Environment:** These resources are intended for development and testing purposes only, not for production use.

---
# Folder list 
 
| Name          | Description   |
| ------------- | ------------- |
| app-scripts | Contains the scripts that are callded by terraform to build the docker container from the Dockerfile in the AWS EC2 and push image to either aws ECR or DockerHub |
| azure_vm_docker_2_docker_hub | Deploys Azure VM instance and builds a docker container and pushes to DockerHub |
| ec2_docker_2_docker_hub | This Terraform configuration sets up an EC2 instance in AWS, configures necessary networking resources, and deploys a Docker container and pushes to DockerHub |
| ec2_docker_2_ecr | This Terraform configuration sets up an EC2 instance in AWS, configures necessary networking resources, and deploys a Docker container and pushes image to ECR |
| ecs_cluster | This Terraform configuration sets up an Amazon ECS Fargate service running NGINX with an ALB (Application Load Balancer) in AWS |


### Current tree structure:
```
├── README.md
├── app-scripts
│   ├── Dockerfile
│   ├── build_docker_image.sh
│   └── build_docker_image_2_ecr.sh
├── azure_vm_docker_2_docker_hub
│   ├── README.md
│   ├── app-scripts
│   │   ├── Dockerfile
│   │   └── build_docker_image.sh
│   ├── ssh-keys
│   │   ├── terraform-azure.pem
│   │   └── terraform-azure.pub
│   └── virtual_machine.tf
├── ec2_docker_2_docker_hub
│   ├── README.md
│   └── ec2_docker_2_docker_hub.tf
├── ec2_docker_2_ecr
│   ├── README.md
│   └── ec2_docker_2_ecr.tf
└── ecs_cluster
    ├── README.md
    └── main.tf
```

---
# apps-scripts

Contains the scripts that are callded by terraform to build the docker container from the Dockerfile and push image to either AWS ECR or DockerHub

---
# azure_vm_docker_2_docker_hub

Deploys Azure VM instance and builds a docker container and pushes to DockerHub

## Features

- Configures Azure provider.
- Creates a resource group.
- Creates a virtual network and subnet.
- Sets up a network security group with HTTP and SSH rules.
- Creates a public IP address.
- Creates a network interface and associates it with the subnet and public IP.
- Launches a Linux virtual machine with the specified image and size.
- Provisions the virtual machine to set up Docker and deploy a container.
- Outputs the URL of the running container.

## Prerequisites

Before using this Terraform configuration, ensure you have:

- An Azure account with permissions for creating resources.
- Installed Terraform.
- Existing SSH key pair for accessing the VM.

## Steps

1. **Configure Azure Provider**
   - Set up Azure provider.

2. **Create Resource Group**
   - Create a resource group in the specified location.

3. **Create Virtual Network**
   - Create a virtual network with the specified address space.

4. **Create Subnet**
   - Create a subnet within the virtual network.

5. **Create Network Security Group**
   - Define security group to allow HTTP (port 80) and SSH (port 22) access.

6. **Create Public IP Address**
   - Create a public IP address with dynamic allocation.

7. **Create Network Interface**
   - Create a network interface and associate it with the subnet and public IP.

8. **Launch Linux Virtual Machine**
   - Launch a Linux VM with the specified image and size.
   - Associate it with the network interface.
   - Use the existing SSH key for access.
   - Provision the VM with custom data for Docker setup.

9. **Provision Virtual Machine**
   - Use `null_resource` to provision the VM.
   - SSH into the VM and set up the environment.
   - Copy necessary files: Docker Hub password, Dockerfile, and build script.
   - Run the build script to set up Docker and deploy the container.
   - Deploys Ubuntu VM instance and builds a docker container and pushes to DockerHub

10. **Output Container URL**
    - Print the URL of the running container.

## Usage

1. **Initialize Terraform**
   - Run `terraform init` to initialize the configuration.
2. **Run a Plan**
   - Run a `terraform plan` to review before applying.
3. **Apply the Configuration**
   - Execute `terraform apply` to create the resources.
4. **Access the Azure VM instance**
   - Use the URL or the VM public ip address to confirm the website was build from the Docker image.
5. **Accees DockerHub repo**
   - Login to your DockerHub repo where you pushed your image to confirm image is there with the correct tag.
  
---
# ec2_docker_2_docker_hub

This Terraform configuration sets up an EC2 instance in AWS, configures necessary networking resources, and deploys a Docker container and pushes to DockerHub

## Features

- Configures AWS provider with proper credentials.
- Creates a default VPC and subnet if they don't exist.
- Fetches available availability zones in the region.
- Creates a security group for the EC2 instance allowing HTTP and SSH access.
- Uses the most recent Amazon Linux 2 AMI.
- Launches an EC2 instance with the specified AMI and instance type.
- Provisions the EC2 instance to set up Docker and deploy a container.
- Outputs the URL of the running container.

## Prerequisites

Before using this Terraform configuration, ensure you have:

- An AWS account with permissions for EC2, VPC, and security groups.
- Installed Terraform.
- Configured AWS CLI with access keys and region.
- Existing key pair for SSH access.

## Steps

1. **Configure AWS Provider**
   - Set up AWS provider with the specified region.

2. **Create Default VPC**
   - Create a default VPC if it doesn't exist.

3. **Fetch Availability Zones**
   - Fetch all available availability zones in the region.

4. **Create Default Subnet**
   - Create a default subnet in the first availability zone.

5. **Create Security Group**
   - Define security group to allow HTTP (port 80) and SSH (port 22) access.

6. **Fetch Amazon Linux 2 AMI**
   - Fetch the most recent Amazon Linux 2 AMI.

7. **Launch EC2 Instance**
   - Launch an EC2 instance with the specified AMI and instance type.
   - Associate it with the default subnet and security group.
   - Use the existing key pair for SSH access.

8. **Provision EC2 Instance**
   - Use `null_resource` to provision the EC2 instance.
   - SSH into the instance and set up the environment.
   - Copy necessary files: Docker Hub password, Dockerfile, and build script.
   - Run the build script to set up Docker and deploy the container.
   - Deploys ec2 instance and builds a docker container and pushes to DockerHub

9. **Output Container URL**
   - Print the URL of the running container.

## Usage

1. **Initialize Terraform**
   - Run `terraform init` to initialize the configuration.
2. **Run a Plan**
   - Run a `terraform plan` to review before applying.
3. **Apply the Configuration**
   - Execute `terraform apply` to create the resources.
4. **Access the ec2 instance**
   - Use the URL or the ec2 public ip address to confirm the website was build from the Docker image.
5. **Accees DockerHub repo**
   - Login to your DockerHub repo where you pushed your image to confirm image is there with the correct tag.

---
# ec2_docker_2_ecr

This Terraform configuration sets up an EC2 instance in AWS, configures necessary networking resources, and deploys a Docker container and pushes image to ECR.

## Features

- Configures AWS provider with proper credentials.
- Creates a default VPC and subnet if they don't exist.
- Fetches available availability zones in the region.
- Creates a security group for the EC2 instance allowing HTTP and SSH access.
- Uses the most recent Amazon Linux 2 AMI.
- Launches an EC2 instance with the specified AMI and instance type.
- Provisions the EC2 instance to set up Docker and deploy a container.
- Outputs the URL of the running container.

## Prerequisites

Before using this Terraform configuration, ensure you have:

- An AWS account with permissions for EC2, VPC, and security groups.
- Installed Terraform.
- Configured AWS CLI with access keys and region.
- Existing key pair for SSH access.

## Steps

1. **Configure AWS Provider**
   - Set up AWS provider with the specified region.

2. **Create Default VPC**
   - Create a default VPC if it doesn't exist.

3. **Fetch Availability Zones**
   - Fetch all available availability zones in the region.

4. **Create Default Subnet**
   - Create a default subnet in the first availability zone.

5. **Create Security Group**
   - Define security group to allow HTTP (port 80) and SSH (port 22) access.

6. **Fetch Amazon Linux 2 AMI**
   - Fetch the most recent Amazon Linux 2 AMI.

7. **Launch EC2 Instance**
   - Launch an EC2 instance with the specified AMI and instance type.
   - Associate it with the default subnet and security group.
   - Use the existing key pair for SSH access.

8. **Provision EC2 Instance**
   - Use `null_resource` to provision the EC2 instance.
   - SSH into the instance and set up the environment.
   - Copy necessary files: credentials, Dockerfile, and build script.
   - Run the build script to set up Docker and deploy the container.
   - Deploys ec2 instance and builds a docker container and pushes to ECR

9. **Output Container URL**
   - Print the URL of the running container.

## Usage

1. **Initialize Terraform**
   - Run `terraform init` to initialize the configuration.
2. **Run a Plan**
   - Run a `terraform plan` to review before applying.
3. **Apply the Configuration**
   - Execute `terraform apply` to create the resources.
4. **Access the ec2 instance**
   - Use the URL or the ec2 public ip address to confirm the website was build from the Docker image.
5. **Accees ECR repo**
   - Login to your AWS ECR repo where you pushed your image to confirm image is there with the correct tag.


---
# ECS Cluster

## ECS Fargate NGINX Service with Terraform

This Terraform configuration sets up an Amazon ECS Fargate service running NGINX with an ALB (Application Load Balancer) in AWS.

## Features

- Creates an ECS cluster for running Fargate tasks.
- Defines an IAM role for ECS task execution.
- Creates an ECS task definition for the NGINX container.
- Configures an ECS service to run the NGINX task with Fargate launch type.
- Sets up an Application Load Balancer (ALB) to route traffic to the NGINX service.
- Configures necessary networking resources: VPC, subnets, and security groups.
- Pulls the NGINX Docker image from an ECR repository.

## Prerequisites

Before using this Terraform configuration, ensure you have:

- An AWS account with permissions for ECS, IAM, and networking resources.
- Installed Terraform (minimum version required: 0.12.x).
- Configured AWS CLI with access keys and region.

## Steps

1. **Configure AWS Provider**
   - Set up AWS provider with the specified region.

2. **Create VPC and Subnets**
   - Create a VPC, subnets, and necessary networking resources.

3. **Create Security Groups**
   - Define security groups for the ALB and ECS tasks.

4. **Create IAM Role**
   - Define an IAM role for ECS task execution.

5. **Create ECS Cluster**
   - Set up an ECS cluster for running Fargate tasks.

6. **Define ECS Task Definition**
   - Create a task definition for the NGINX container.

7. **Create ALB**
   - Set up an Application Load Balancer (ALB) and target group.

8. **Create ECS Service**
   - Configure an ECS service to run the NGINX task with Fargate launch type.

9. **Outputs**
   - Print the DNS name of the ALB to access the NGINX service.

## Usage

1. **Initialize Terraform**
   - Run `terraform init` to initialize the configuration.
2. **Run a Plan**
   - Run a `terraform plan` to review before applying.
3. **Apply the Configuration**
   - Execute `terraform apply` to create the resources.
4. **Access the NGINX Service**
   - Use the printed ALB DNS name to access the NGINX service.
