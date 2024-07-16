# ECS Fargate NGINX Service with Terraform

This Terraform code sets up an Amazon ECS Fargate service running NGINX with an ALB (Application Load Balancer) in AWS.

## Features

- Creates an ECS cluster for running Fargate tasks.
- Defines an IAM role for ECS task execution.
- Creates an ECS task definition for the NGINX container.
- Configures an ECS service to run the NGINX task in Fargate launch type.
- Sets up an Application Load Balancer (ALB) to route traffic to the NGINX service.
- Configures necessary networking resources like VPC, subnets, and security groups.
- Pulls the NGINX Docker image from an ECR repository.

## Prerequisites

Before using this Terraform configuration, make sure you have:

- An AWS account with appropriate permissions to create ECS, IAM, and networking resources.
- Installed Terraform (minimum version required: 0.12.x).
- Configured AWS CLI with appropriate access keys and region.

## Usage

1. Clone this repository:


git clone <repository_url>
cd <repository_directory>


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.my_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.my_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.my_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy_attachment.task_execution_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
