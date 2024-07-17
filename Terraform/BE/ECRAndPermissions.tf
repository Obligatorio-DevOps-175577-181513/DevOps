provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "ecsTaskExecutionRole2" {
  name = "ecsTaskExecutionRole2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ecsTaskExecutionRole2"
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole2_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecr_repository" "service_repos" {
  for_each             = toset(var.service_names)
  name                 = "${each.value}${var.environment}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${each.value}${var.environment}"
  }
}

resource "aws_ecr_repository_policy" "service_policies" {
  for_each = aws_ecr_repository.service_repos

  repository = each.value.name
  policy     = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "new statement"
        Effect = "Allow"
        Principal = {
          AWS = var.principal_arn
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}