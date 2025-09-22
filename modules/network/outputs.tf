output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
