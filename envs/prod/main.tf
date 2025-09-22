# ==========================================
# Módulos
# ==========================================

module "network" {
  source              = "../../modules/network"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]    # mínimo 2 subnets públicas
  private_subnet_cidrs= ["10.0.11.0/24", "10.0.12.0/24"]  # mínimo 2 subnets privadas
  azs                 = ["us-east-1a", "us-east-1b"]
}

module "dynamodb" {
  source = "../../modules/dynamodb"
}

module "redis" {
  source     = "../../modules/redis"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
}

module "secrets" {
  source  = "../../modules/secrets"
  secrets = var.secrets
}

# ==========================================
# Backend ECS (Node.js)
# ==========================================
module "ecs" {
  source              = "../../modules/ecs"
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  public_subnet_ids   = module.network.public_subnet_ids
  alb_target_group_arn= module.network.alb_target_group_arn
  alb_sg_id           = module.network.alb_sg_id
  redis_endpoint      = module.redis.redis_endpoint
  secrets_arns        = values(module.secrets.secret_arns)

  # usar rol preexistente en Learner Lab
  execution_role_arn  = "arn:aws:iam::992382706759:role/ecsTaskExecutionRole"
}

# ==========================================
# Vexa ECS (Fargate)
# ==========================================
module "ecs_vexa" {
  source              = "../../modules/ecs_vexa"
  private_subnet_ids  = module.network.private_subnet_ids
  alb_target_group_arn= module.network.alb_target_group_arn
  cluster_id          = module.ecs.cluster_id

  # usar rol preexistente en Learner Lab
  execution_role_arn  = "arn:aws:iam::992382706759:role/ecsTaskExecutionRole"
}

# ==========================================
# Frontend (S3 website hosting)
# ==========================================
module "s3_frontend" {
  source      = "../../modules/s3_cloudfront"
  bucket_name = var.bucket_name
}
