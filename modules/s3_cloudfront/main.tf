# Bucket para el frontend
resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
  tags   = merge(var.tags, { Name = var.bucket_name })
}

# Configuración de sitio web estático
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
