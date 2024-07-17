resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-175577-181513"
}


resource "aws_security_group" "Terraform_Security" {
  name        = "TerraformSecurity${var.environment}"
  description = "Security group for ECS instances"
  vpc_id      = "vpc-0f53ae71a4dd42e5f"

  ingress {
    from_port   = 8080
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.environment}MS"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-020d09cc7923f9bf2", "subnet-04f4a1934f9f7c151"]
    security_groups = [aws_security_group.Terraform_Security.id]
    assign_public_ip = true
  }
}