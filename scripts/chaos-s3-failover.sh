#!/bin/bash
set -e
export AWS_PROFILE=wizard
SITE="https://d15gdt59kdhi5t.cloudfront.net"
BUCKET_PRIMARY="wizard-site-primary-sa-east-1-536"
BUCKET_DR="wizard-site-dr-us-east-1-536"
echo "=== CHAOS - S3 FAILOVER TEST ==="
echo "1. Status ANTES:"
curl -s -I $SITE | head -2
echo "2. Deletando primary s3://$BUCKET_PRIMARY/index.html"
aws s3 rm s3://$BUCKET_PRIMARY/index.html --region sa-east-1 || true
echo "Aguardando 15s CloudFront Origin Group failover..."
sleep 15
echo "3. Status DEPOIS (deve continuar 200 vindo do DR):"
curl -s -I $SITE | head -2
curl -s $SITE | head -5
echo "4. Restaurando..."
echo "<h1>Wizard Time-02 - Restaurado - $(date -u)</h1>" | aws s3 cp - s3://$BUCKET_PRIMARY/index.html --region sa-east-1 --content-type text/html --cache-control no-cache
echo "OK"
