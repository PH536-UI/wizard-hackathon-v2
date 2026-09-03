#!/bin/bash
set -e
export AWS_PROFILE=wizard
export AWS_REGION=us-east-1
API="https://sjlpov3e8f.execute-api.us-east-1.amazonaws.com"
TABLE="wizard-app-data"
TEAM="Time-02"
EMAIL="paulohenriquepereira2020@gmail.com"

echo "=== WIZARD HACKATHON 2026 - $TEAM ==="
echo "Email: $EMAIL"
echo ""

echo "[1/5] Terraform outputs"
cd ~/wizard-hackathon-v2/terraform
terraform output

echo ""
echo "[2/5] Health Check"
curl -s $API/health | jq .

echo ""
echo "[3/5] POST /api/v1/resource (Producer -> SQS)"
RESPONSE=$(curl -s -X POST $API/api/v1/resource \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$TEAM\",\"email\":\"$EMAIL\"}")
echo $RESPONSE | jq .
MSG_ID=$(echo $RESPONSE | jq -r .message_id)
echo "MessageID: $MSG_ID"

echo ""
echo "[4/5] Aguardando worker (5s)..."
sleep 5
aws dynamodb query --table-name $TABLE \
  --key-condition-expression "pk = :pk" \
  --expression-attribute-values '{":pk":{"S":"lead"}}' \
  --region us-east-1 | jq '.Items[] | {name: .name.S, email: .email.S, sk: .sk.S, processed_at: .processed_at.N}'

echo ""
echo "[5/5] SQS Status (deve estar vazia = consumida)"
aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/350146358260/wizard-app-queue \
  --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible --region us-east-1

echo ""
echo "=== FIM DEMO - Tudo OK ==="
echo "Endpoints:"
echo "  API: $API"
echo "  Health: $API/health"
echo "  Resource: $API/api/v1/resource"
echo "  CloudFront: https://dpm2y3dsdugyx.cloudfront.net"
echo "  Dynamo Table: $TABLE"
echo "  WAF: arn:aws:wafv2:us-east-1:350146358260:global/webacl/wizard-ddos-mitigation/9d7a1caf-1072-4264-ac9d-80e53f07b826"
