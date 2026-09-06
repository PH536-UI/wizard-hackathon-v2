#!/bin/bash
set -e
export AWS_PROFILE=wizard
echo "=== PREPARA DEMO ==="
echo "<h1>Wizard - Time 02 - Vitrine no Ar - $(date -u)</h1>" | aws s3 cp - s3://wizard-site-primary-sa-east-1-536/index.html --region sa-east-1 --content-type text/html --cache-control no-cache
echo "<h1>Wizard - Time 02 - DR</h1>" | aws s3 cp - s3://wizard-site-dr-us-east-1-536/index.html --region us-east-1 --content-type text/html --cache-control no-cache || true
echo "Invalidando CloudFront..."
aws cloudfront create-invalidation --distribution-id d15gdt59kdhi5t --paths "/*" --region us-east-1 || true
echo "Testando..."
curl -s https://dpm2y3dsdugyx.cloudfront.net/health
echo ""
curl -s -I https://d15gdt59kdhi5t.cloudfront.net | head -2
echo "Pronto para demo"
