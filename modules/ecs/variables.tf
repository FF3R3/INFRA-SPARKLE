variable "name" {
  type    = string
  default = "tesis-ecs"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "redis_endpoint" {
  type = string
}

variable "secrets_arns" {
  type = list(string)
}

variable "execution_role_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = { Project = "tesis-educacion" }
}
