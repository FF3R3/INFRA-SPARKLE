# Infraestructura Tesis - Entorno Prod

Este entorno levanta la arquitectura mínima para el MVP en AWS Learner Lab:

- **network/** → VPC, subnets públicas/privadas, NAT Gateway y ALB.  
- **dynamodb/** → Tabla única `tesis-main` con diseño multi-entidad (`pk`, `sk`).  
- **redis/** → Cluster mínimo de Redis (`cache.t4g.micro`) para presencia y actividades en vivo.  
- **ecs/** → Backend Node.js en Fargate conectado al ALB.  
- **ecs_vexa/** → Servicio VexaAI también en Fargate (antes era GPU).  
- **s3_cloudfront/** → SPA frontend en S3 servido por CloudFront (con soporte para dominio propio).  
- **secrets/** → Secrets Manager con claves como `openai_api_key` y `vexa_api_key`.  

---

## 📦 Requisitos previos

1. Acceso a **AWS Academy Learner Lab** con credenciales activas.  
2. Terraform >= 1.6.0 (instalado manualmente en el entorno).  
3. Git configurado para clonar el repo.  

> ⚠️ Nota: No se usa S3 ni DynamoDB como backend de estado en Learner Lab. El estado queda local en la sesión.

---

## 🚀 Despliegue desde cero en AWS Learner Lab

### 1. Preparar el entorno
Abrir la terminal del Learner Lab y limpiar cualquier clon previo:
```bash
rm -rf ~/INFRA-SPARKLE
cd ~
git clone https://github.com/FF3R3/INFRA-SPARKLE.git
cd INFRA-SPARKLE/envs/prod
cd ~/INFRA-SPARKLE/envs/prod
terraform init
terraform plan
terraform apply -auto-approve
