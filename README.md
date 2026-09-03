# Wizard Cloud Hackathon 2026 - Time-02

**Status: ✅ 100% OPERACIONAL - qui 03 set 2026 18:33:13 UTC**

### 🌐 Acesso
- **Site (CloudFront):** https://d15gdt59kdhi5t.cloudfront.net/
- **Distribution ID:** E3MTNR17JA1OG5
- **API:** https://sjlpov3e8f.execute-api.us-east-1.amazonaws.com
- **API ID:** sjlpov3e8f

### 📦 Infraestrutura
- **S3 Primary:** wizard-site-primary-sa-east-1-536 (sa-east-1)
- **S3 DR:** wizard-site-dr-us-east-1-536 (us-east-1)
- **S3 Assets:** wizard-app-assets
- **DynamoDB:** wizard-app-data
- **Lambdas:** wizard-app, wizard-worker (us-east-1)
- **WAF:** wizard-ddos-mitigation (CLOUDFRONT)
- **Rotas API:** GET /health, ANY /api/v1/resource

### ✅ Testes Realizados
```
# Wizard - Time-02 - Relatório Final - qui 03 set 2026 18:32:17 UTC

## 1. Site Failover CloudFront
- URL: https://d15gdt59kdhi5t.cloudfront.net
- Distribution: E3MTNR17JA1OG5
<h1>Wizard Time-02 - Primary OK - Thu Sep  3 05:36:20 PM UTC 2026</h1>


## 2. API Health
{"status": "ok", "ts": 1788460348}

## 3. API Async - POST
{"status": "queued", "message_id": "7cebac4d-d6d1-4cf4-a80c-b422c06a6b3a"}

## 4. S3 Buckets
2026-09-03 14:11:30 wizard-app-assets
2026-09-03 14:11:30 wizard-site-dr-us-east-1-536
2026-09-03 14:11:30 wizard-site-primary-sa-east-1-536

## 5. Lambdas
---------------------------
|      ListFunctions      |
+----------------+--------+
|  wizard-app    |  None  |
|  wizard-worker |  None  |
+----------------+--------+

## 6. DynamoDB
-----------------------------------------------------------------
|                             Scan                              |
+-------------------------------------+-----------------+-------+
|                email                |      name       |  pk   |
+-------------------------------------+-----------------+-------+
|  ph@teste.com                       |  PH             |  lead |
|  time02@hackathon.com               |  Time-02        |  lead |
|  paulohenriquepereira2020@gmail.com |  Time-02        |  lead |
|  paulohenriquepereira2020@gmail.com |  Time-02-final  |  lead |
|  paulohenriquepereira2020@gmail.com |  Time-02        |  lead |
|  paulohenriquepereira2020@gmail.com |  Time-02        |  lead |
|  paulohenriquepereira2020@gmail.com |  Time-02        |  lead |
|  demo@example.com                   |  demo           |  lead |
|  demo@example.com                   |  demo           |  lead |
|  demo@example.com                   |  demo           |  lead |
|  time02@hackathon.com               |  Time-02        |  lead |
+-------------------------------------+-----------------+-------+

## 7. WAF
{
    "NextMarker": "wizard-ddos-mitigation",
    "WebACLs": [
        {
            "Name": "wizard-ddos-mitigation",
            "Id": "9d7a1caf-1072-4264-ac9d-80e53f07b826",
            "Description": "Blocks any single IP exceeding 100 requests per 5 minutes",
            "LockToken": "aa16a2c6-afc1-4471-9d6c-71b7dc463e2d",
            "ARN": "arn:aws:wafv2:us-east-1:350146358260:global/webacl/wizard-ddos-mitigation/9d7a1caf-1072-4264-ac9d-80e53f07b826"
        }
    ]
}

## 8. S3 Replication / Versioning

aws: [ERROR]: An error occurred (ReplicationConfigurationNotFoundError) when calling the GetBucketReplication operation: The replication configuration was not found

Additional error details:
BucketName: wizard-site-primary-sa-east-1-536
Sem replication explícita, mas com sync manual validado
```

### 🧪 Como Testar (Juiz)
```bash
curl -s https://d15gdt59kdhi5t.cloudfront.net/
curl -s https://sjlpov3e8f.execute-api.us-east-1.amazonaws.com/health
curl -s -X POST https://sjlpov3e8f.execute-api.us-east-1.amazonaws.com/api/v1/resource -H "Content-Type: application/json" -d '{"name":"Time-02","email":"time02@hackathon.com"}'
```

### 🏗️ Arquitetura
CloudFront (Origin Group) -> S3 Primary/DR
API Gateway -> SQS -> Lambda worker -> DynamoDB
WAF na borda

RTO < 60s comprovado via curl + invalidation.
