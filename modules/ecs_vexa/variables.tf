variable "name" {
  type    = string
  default = "tesis-ecs-vexa"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = { Project = "tesis-educacion" }
}

variable "execution_role_arn" {
  type = string
}

variable "cluster_id" {
  type = string
}
