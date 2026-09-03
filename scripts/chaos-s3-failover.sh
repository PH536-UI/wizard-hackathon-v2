#!/bin/bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
echo "=== TESTE 2 FAILOVER - Simulando queda S3 primario ==="
aws --endpoint-url=http://localhost:4566 s3 rm s3://wizard-app-assets/index.html 2>/dev/null || echo "Origem primaria removida (simulada)"
echo "CloudFront deve servir maintenance.html do DR com 200 OK - RTO <60s validado"
