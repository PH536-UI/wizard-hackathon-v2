# Wizard - Time-02 - Dossiê de Resiliência - Trilha 2

**Pergunta central**: Minha vitrine continua no ar quando algo quebra ou me atacam?
**URL Site**: https://d15gdt59kdhi5t.cloudfront.net
**URL API Edge**: https://dpm2y3dsdugyx.cloudfront.net

## 1. Arquitetura
Cliente (S3 Website) -> CloudFront OAC -> Origin Group [Primary sa-east-1 + DR us-east-1] Failover 500/502/503/504
Cliente -> CloudFront + WAF (Rate 100/5min) -> APIGW HTTP API -> Lambda producer -> SQS -> Lambda consumer -> DynamoDB wizard-app-data

## 2. Blindagem (WAF + OAC + GuardDuty)
- S3 PublicAccessBlock = true, acesso só via OAC com SourceArn = distribution
- WAFv2 Global + Regional RateLimit100 IP
- GuardDuty habilitado para detecção
- maintenance.html custom_error_response 403/500 -> 200

## 3. Failover - Prova Game Day
Para demonstrar no pitch de 5min:
`aws s3 rm s3://wizard-site-primary-sa-east-1-536/index.html --region sa-east-1 && curl -i https://d15gdt59kdhi5t.cloudfront.net`
Esperado: 200 vindo do DR (wizard-site-dr-us-east-1-536)

## 4. Custo e Tags
- Budgets com alarme
- Tag Project=WizardResilience2026 em todos recursos
- PriceClass_100 para otimizar custo

## 5. Teardown
terraform destroy -auto-approve
