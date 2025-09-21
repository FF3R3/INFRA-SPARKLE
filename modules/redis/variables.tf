variable "name" {
  type    = string
  default = "tesis-redis"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = { Project = "tesis-educacion" }
}
