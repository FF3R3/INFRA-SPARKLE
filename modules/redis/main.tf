# Security Group para Redis
resource "aws_security_group" "redis_sg" {
  name        = "${var.name}-sg"
  description = "Permite acceso a Redis en 6379 desde VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # limitar al rango de la VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-sg" })
}

# Subnet Group
resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.name}-subnets"
  subnet_ids = var.subnet_ids
}

# Redis cluster (mínimo viable)
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.name
  engine               = "redis"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  port                 = 6379
  tags                 = var.tags
}
