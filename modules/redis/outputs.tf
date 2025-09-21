output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.configuration_endpoint
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
