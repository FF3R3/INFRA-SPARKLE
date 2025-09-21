variable "secrets" {
  type = map(string)
  # ejemplo de uso en terraform.tfvars:
  # secrets = {
  #   openai_api_key = "sk-xxxx"
  #   vexa_api_key   = "vx-xxxx"
  # }
}
