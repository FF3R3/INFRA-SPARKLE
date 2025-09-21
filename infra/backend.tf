terraform {
  backend "s3" {
    bucket         = "tfstate-tesis-educacion"   # Crear este bucket a mano la primera vez
    key            = "infra/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locks"             # Crear esta tabla a mano la primera vez
    encrypt        = true
  }
}
