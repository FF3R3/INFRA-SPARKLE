# Task Definition para Vexa
resource "aws_ecs_task_definition" "vexa" {
  family                   = "${var.name}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  # Rol de ejecución viene desde el entorno (main.tf)
  execution_role_arn = var.execution_role_arn
  # Si querés darle permisos adicionales al contenedor, podés agregar un task_role_arn distinto

  container_definitions = jsonencode([
    {
      name      = "vexa"
      image     = "REEMPLAZAR-CON-TU-DOCKER-VEXA" # 👈 Imagen en ECR o Docker Hub
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/vexa"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
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
    assign_public_ip = true  # ⚠️ En Learner Lab necesitás IP pública
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "vexa"
    container_port   = 5000
  }

  depends_on = [aws_ecs_task_definition.vexa]
}
