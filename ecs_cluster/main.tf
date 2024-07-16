provider "aws" {
#   access_key = "aws_access_key_id"
#   secret_key = "aws_secret_access_key"
  region     = "us-east-1"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_iam_role" "task_execution_role" {
  name               = "my-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect"   : "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action"   : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "task_execution_policy_attachment" {
  name = "AmazonECSTaskExecutionRolePolicy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.task_execution_role.name]
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-definition"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # CPU units (Fargate minimum: 256)
  memory                   = "512"  # Memory in MB (Fargate minimum: 0.5 GB)

  container_definitions = jsonencode([
    {
      "name"            : "my-container",
      "image"           : "nginx",  # Example image
      # "image"           : "123456789012.dkr.ecr.us-east-1.amazonaws.com/test:latest"
      "cpu"             : 256,      # CPU units for the container
      "memory"          : 512,      # Memory for the container in MB
      "portMappings"    : [
        {
          "containerPort": 80,
          "hostPort"     : 80,
          "protocol"     : "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 2  # Number of tasks to run
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-098b2e1ba9abcd1234"]  # Replace with your subnet ID
    security_groups  = ["sg-05b67b0747bdabcd1234"]      # Replace with your security group ID
    assign_public_ip = true
  }
}
