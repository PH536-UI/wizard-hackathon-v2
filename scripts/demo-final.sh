#!/bin/bash
set -e
export AWS_PROFILE=wizard
SITE="https://d15gdt59kdhi5t.cloudfront.net"
API="https://dpm2y3dsdugyx.cloudfront.net/health"
echo "=== TIME-02 PITCH 5MIN - 08/09/2026 ==="
echo "1. SAUDE:"; curl -s $API; echo ""
echo "2. WAF BLOCK (200 req paralelo):"
seq 1 200 | xargs -P50 -I{} curl -s -o /dev/null -w "%{http_code}\n" "$API?b={}" | sort | uniq -c
sleep 65
echo "-> Apos janela WAF:"; curl -s -o /dev/null -w "%{http_code}\n" $API; echo "403 = BLOQUEADO"
echo "3. FAILOVER SITE:"; curl -s -I $SITE | head -1
echo "Pitch OK - vitrine continua no ar"
