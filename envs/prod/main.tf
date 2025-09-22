# ==========================================
# IAM ROLE para ECS Tasks (compartido)
# ==========================================
resource "aws_iam_role" "ecs_task_execution" {
  name_prefix = "ecs-task-exec-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ==========================================
# Módulos
# ==========================================
module "network" {
  source              = "../../modules/network"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  private_subnet_cidrs= ["10.0.11.0/24"]
  azs                 = ["us-east-1a"]
}

module "dynamodb" {
  source = "../../modules/dynamodb"
}

module "redis" {
  source      = "../../modules/redis"
  vpc_id      = module.network.vpc_id
  subnet_ids  = [module.network.private_subnet_id]
}

module "secrets" {
  source  = "../../modules/secrets"
  secrets = var.secrets
}

module "ecs" {
  source              = "../../modules/ecs"
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = [module.network.private_subnet_id]
  public_subnet_ids   = [module.network.public_subnet_id]
  alb_target_group_arn= module.network.alb_target_group_arn
  alb_sg_id           = module.network.alb_sg_id
  redis_endpoint      = module.redis.redis_endpoint
  secrets_arns        = values(module.secrets.secret_arns)
  execution_role_arn  = aws_iam_role.ecs_task_execution.arn
}

module "ecs_vexa" {
  source              = "../../modules/ecs_vexa"
  private_subnet_ids  = [module.network.private_subnet_id]
  alb_target_group_arn= module.network.alb_target_group_arn
  execution_role_arn  = aws_iam_role.ecs_task_execution.arn
  cluster_id          = module.ecs.cluster_id
}


module "s3_cloudfront" {
  source             = "../../modules/s3_cloudfront"
  bucket_name        = var.bucket_name
  domain_name        = var.domain_name
  acm_certificate_arn= var.acm_certificate_arn
}
