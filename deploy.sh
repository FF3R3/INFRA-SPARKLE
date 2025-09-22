#!/bin/bash
set -e

echo "===== Actualizando repo desde GitHub ====="
cd ~/INFRA-SPARKLE
git fetch origin main
git reset --hard origin/main

echo "===== Entrando al entorno de producción ====="
cd envs/prod

echo "===== Inicializando Terraform ====="
terraform init -upgrade

echo "===== Mostrando plan ====="
terraform plan

echo "===== Aplicando cambios ====="
terraform apply -auto-approve

echo "===== Deploy completado ====="
