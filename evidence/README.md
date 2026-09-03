# Wizard Hackathon 2026 - Time-02
Email: paulohenriquepereira2020@gmail.com

## Arquitetura
API Gateway (sjlpov3e8f) -> Lambda Producer (wizard-app) -> SQS (wizard-app-queue) -> Lambda Worker (wizard-worker) -> DynamoDB (wizard-app-data)
CloudFront dpm2y3dsdugyx.cloudfront.net + WAF ddos-mitigation

## Endpoints Validados
- GET /health -> 200 {"status":"ok"}
- POST /api/v1/resource -> 202 {"status":"queued"}

## Evidências
- terraform-output.txt
- health.json
- post-202.json
- dynamo-leads.json
- demo-final.log

## Observação SCP
GuardDuty detector c10cb548bd794551877cd2b5595d9eeb não pode ser deletado:
AccessDeniedException with explicit deny in service control policy p-8rjxyj7h
Solução: terraform state rm aws_guardduty_detector.main
