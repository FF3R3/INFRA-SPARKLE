variable "bucket_name" {
  type    = string
  default = "tesis-frontend-spa"
}

variable "domain_name" {
  type    = string
  default = null
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

variable "secrets" {
  type = map(string)
}
