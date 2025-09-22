# Task Definition para Vexa (sin execution_role_arn en Learner Lab)
resource "aws_ecs_task_definition" "vexa" {
  family                   = "${var.name}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "vexa"
      image     = "REEMPLAZAR-CON-TU-DOCKER-VEXA"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Service para Vexa
resource "aws_ecs_service" "vexa" {
  name            = "${var.name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.vexa.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = true # necesario en Learner Lab
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "vexa"
    container_port   = 5000
  }

  depends_on = [aws_ecs_task_definition.vexa]
}

# Outputs útiles
output "vexa_service_name" {
  value = aws_ecs_service.vexa.name
}

output "vexa_task_definition" {
  value = aws_ecs_task_definition.vexa.arn
}
