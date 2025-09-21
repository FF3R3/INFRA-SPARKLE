# Infraestructura Tesis - Entorno Prod

Este entorno levanta la arquitectura mínima para el MVP:

- **network/** → VPC, subnets públicas/privadas, NAT Gateway y ALB.  
- **dynamodb/** → Tabla única `tesis-main` con diseño multi-entidad (`pk`, `sk`).  
- **redis/** → Cluster mínimo de Redis (`cache.t4g.micro`) para presencia y actividades en vivo.  
- **ecs/** → Backend Node.js (Fargate) conectado al ALB.  
- **ecs_gpu/** → Servicio VexaAI sobre ECS con instancia EC2 GPU (`g4dn.xlarge`).  
- **s3_cloudfront/** → SPA frontend en S3 servido por CloudFront (con soporte para dominio propio).  
- **secrets/** → Secrets Manager con claves como `openai_api_key` y `vexa_api_key`.  

---

##  Requisitos previos
1. AWS CLI configurado con credenciales.  
2. Terraform >= 1.6.0.  
3. Bucket S3 y tabla DynamoDB para backend de estado:  
   ```bash
   aws s3 mb s3://tfstate-tesis-educacion --region us-east-1
   aws dynamodb create-table \
     --table-name tfstate-locks \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST \
     --region us-east-1
