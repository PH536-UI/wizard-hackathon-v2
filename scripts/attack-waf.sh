#!/bin/bash
set -e
export AWS_PROFILE=wizard
API="https://dpm2y3dsdugyx.cloudfront.net/health"
echo "=== WAF TEST - 110 reqs contra $API ==="
for i in {1..110}; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" $API)
  if [ "$CODE" = "403" ]; then echo "Req $i: 403 FORBIDDEN - BLOQUEADO [OK]"; else echo "Req $i: $CODE"; fi
done
