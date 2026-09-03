#!/bin/bash
set -e
echo "=== PREPARANDO TUDO ==="
docker ps | grep floci || docker compose up -d
sleep 2
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
cd ~/wizard-hackathon-v2/terraform
terraform validate
API_ID=$(terraform output -raw api_gateway_endpoint | awk -F[/.] '{print $3}')
ENDPOINT="http://localhost:4566/execute-api/$API_ID/\$default"
curl -s "$ENDPOINT/api/v1/resource" -X POST -H 'Content-Type: application/json' -d '{"name":"Healthcheck","email":"health@wizard.local"}' | python3 -m json.tool
echo "Dynamo total:"
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name wizard-app-data --select COUNT --output text
echo "PRONTO!"
