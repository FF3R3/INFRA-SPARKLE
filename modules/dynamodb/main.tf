resource "aws_dynamodb_table" "this" {
  name         = var.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  # Ejemplo de índice secundario para búsquedas por email de usuario
  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = "email_index"
    hash_key        = "email"
    projection_type = "ALL"
  }

  tags = merge(var.tags, { Name = var.name })
}
