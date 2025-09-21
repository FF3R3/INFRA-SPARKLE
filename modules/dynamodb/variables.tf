variable "name" {
  type    = string
  default = "tesis-main"
}

variable "tags" {
  type    = map(string)
  default = { Project = "tesis-educacion" }
}
