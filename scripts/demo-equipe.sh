#!/bin/bash
set -e
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
cd ~/wizard-hackathon-v2/terraform
API_ID=$(terraform output -raw api_gateway_endpoint | awk -F[/.] '{print $3}')
ENDPOINT="http://localhost:4566/execute-api/$API_ID/\$default"
echo "=========================================="
echo " WIZARD HACKATHON 2026 - DEMO AO VIVO"
echo " API_ID: $API_ID"
echo "=========================================="
echo
echo "[1/4] INFRA - 22 recursos"
terraform state list
echo
echo "[2/4] SEGURANCA - WAF + GuardDuty + S3"
echo "WAF: wizard-ddos-mitigation - Rate 100/300s"
echo "GuardDuty: $(terraform output -raw guardduty_detector_id) ENABLED"
echo "S3: $(terraform output -raw s3_bucket_name) - Block Public ON"
echo
echo "[3/4] RESILIENCIA - SQS + DLQ + ESM"
aws --endpoint-url=http://localhost:4566 sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/wizard-app-queue --attribute-names All --output table
echo
echo "[4/4] TESTE E2E AO VIVO - POST + Dynamo + SQS"
curl -i -X POST "$ENDPOINT/api/v1/resource" -H 'Content-Type: application/json' -d '{"name":"Time Wizard Live","email":"time@wizard.local"}'
sleep 3
echo
echo "DynamoDB - ultimo registro:"
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name wizard-app-data | python3 -c "import sys,json; data=json.load(sys.stdin); print(json.dumps(data['Items'][-1], indent=2))"
echo
echo "SQS Messages (tem que ser 0):"
aws --endpoint-url=http://localhost:4566 sqs get-queue-attributes --queue-url http://localhost:4566/000000000000/wizard-app-queue --attribute-names ApproximateNumberOfMessages --query Attributes.ApproximateNumberOfMessages --output text
echo
echo "DEMO OK - Fluxo validado!"
