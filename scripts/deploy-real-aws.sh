#!/bin/bash
set -e
echo "=== DEPLOY REAL AWS ==="
echo "1. Exporte suas credenciais reais:"
echo " export AWS_ACCESS_KEY_ID=..."
echo " export AWS_SECRET_ACCESS_KEY=..."
echo " export AWS_DEFAULT_REGION=us-east-1"
read -p "Credenciais reais configuradas? (y/n) " -n 1 -r; echo
if [[! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi
cd ~/wizard-hackathon-v2/terraform
terraform init
terraform plan -var='use_local_emulator=false' -out=wizard-real.tfplan
echo "Confira o plan. Se ok:"
echo "terraform apply wizard-real.tfplan"
echo "Depois:"
echo "terraform output api_gateway_endpoint"
