variable "bucket_name" {
  type    = string
  default = "tesis-frontend-spa"
}

variable "domain_name" {
  type    = string
  default = null # ejemplo: "app.tesis.edu"
}

variable "acm_certificate_arn" {
  type    = string
  default = null # ARN del certificado SSL en us-east-1
}

variable "tags" {
  type    = map(string)
  default = { Project = "tesis-educacion" }
}
