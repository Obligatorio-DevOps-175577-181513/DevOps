resource "aws_ecs_task_definition" "task_definition" {
  family                   = "Task-${var.environment}"
  execution_role_arn       = var.principal_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "be-orders"
      image     = "767397879171.dkr.ecr.us-east-1.amazonaws.com/ordersservice${var.environment}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          name          = "be-orders-8080-tcp"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      command = [
        "http://be-shipping:8083",
        "http://be-payments:8081",
        "http://be-products:8082"
      ]
      environment = [
        {
          name  = "SERVER_PORT"
          value = "8080"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/Task-${var.environment}"
          awslogs-create-group  = "true"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = "be-payments"
      image     = "767397879171.dkr.ecr.us-east-1.amazonaws.com/paymentsservice${var.environment}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          name          = "be-payments-8081-tcp"
          containerPort = 8081
          hostPort      = 8081
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "SERVER_PORT"
          value = "8081"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/Task-${var.environment}"
          awslogs-create-group  = "true"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = "be-products"
      image     = "767397879171.dkr.ecr.us-east-1.amazonaws.com/productsservice${var.environment}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          name          = "be-products-8082-tcp"
          containerPort = 8082
          hostPort      = 8082
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "SERVER_PORT"
          value = "8082"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/Task-${var.environment}"
          awslogs-create-group  = "true"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = "be-shipping"
      image     = "767397879171.dkr.ecr.us-east-1.amazonaws.com/shippingservice${var.environment}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          name          = "be-shipping-8083-tcp"
          containerPort = 8083
          hostPort      = 8083
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "SERVER_PORT"
          value = "8083"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/Task-${var.environment}"
          awslogs-create-group  = "true"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}