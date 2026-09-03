#!/bin/bash
TARGET=$(terraform output -raw api_gateway_endpoint 2>/dev/null | head -1)
if [[ -z "$TARGET" ]]; then TARGET="http://localhost:4566/execute-api/932d798a4b/\$default/api/v1/resource"; fi
echo "=== TESTE 1 WAF - 110 reqs - deve dar 403 ==="
for i in {1..110}; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST $TARGET -H 'Content-Type: application/json' -d '{"name":"spam","email":"spam@test.com"}')
  if [ "$CODE" = "403" ]; then echo "Req $i: [403 FORBIDDEN - BLOQUEADO]"; else echo "Req $i: $CODE"; fi
done
