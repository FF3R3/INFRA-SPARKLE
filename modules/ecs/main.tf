# ECS Cluster (compartido para backend y Vexa)
resource "aws_ecs_cluster" "this" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

# Task Definition para Backend (sin execution_role_arn en Learner Lab)
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.name}-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "REEMPLAZAR-CON-TU-DOCKER-BACKEND"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "REDIS_ENDPOINT", value = var.redis_endpoint }
      ]
    }
  ])
}

# ECS Service para Backend
resource "aws_ecs_service" "backend" {
  name            = "${var.name}-backend-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = true # necesario en Learner Lab
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "backend"
    container_port   = 3000
  }

  depends_on = [aws_ecs_task_definition.backend]
}

# Output para compartir el cluster con ecs_vexa
output "cluster_id" {
  value = aws_ecs_cluster.this.id
}
