# 🚀 Wizard Cloud Hackathon 2026

## Serverless Cloud Infrastructure

Infraestrutura AWS Serverless como código (IaC), desenvolvida para o Wizard Cloud Hackathon 2026 e validada localmente com Floci.

Arquitetura orientada a eventos utilizando Terraform, API Gateway, Lambda, SQS, DLQ, DynamoDB, S3, WAF, GuardDuty, SNS e IAM.
---

## 🏗️ Arquitetura

```text
Cliente
   |
   v
API Gateway
   |
   v
Lambda: wizard-app
   |
   v
SQS: wizard-app-queue
   |
   +------------------> DLQ: wizard-app-dlq
   |
   v
Lambda: wizard-worker
   |
   v
DynamoDB: wizard-app-data
```
---

## 🔄 Fluxo de negócio

1. Cliente envia POST /api/v1/resource.
2. API Gateway encaminha para wizard-app.
3. wizard-app publica o evento no SQS.
4. API retorna HTTP 202 Accepted.
5. SQS aciona wizard-worker.
6. Worker grava os dados no DynamoDB.
7. Falhas persistentes são encaminhadas para a DLQ.

---

## 🔐 Segurança

### WAF

Web ACL: wizard-ddos-mitigation

Rate limit: 100 requests / 300 seconds / IP

Action: Block

### GuardDuty

Status: ENABLED

### S3

Bucket: wizard-app-assets

Public Access Block habilitado.

### IAM

Políticas de menor privilégio são utilizadas pelas funções Lambda.

---

## 🛡️ Resiliência

SQS fornece processamento assíncrono, retries e isolamento de falhas.

Event Source Mapping:

- Status: Enabled
- BatchSize: 10
- ReportBatchItemFailures

DLQ: wizard-app-dlq

maxReceiveCount: 3
---

## 🧪 Floci

Endpoint local: http://localhost:4566

Região: us-east-1

Credenciais locais:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
```

Validar:

```bash
aws --endpoint-url=http://localhost:4566 sts get-caller-identity
```

---

## ⚙️ Terraform

```bash
cd terraform
terraform init
terraform validate
terraform plan
```

Validação registrada neste ambiente:

```text
Plan: 0 to add, 1 to change, 0 to destroy
```

Alteração pendente:

aws_lambda_event_source_mapping.worker_sqs

maximum_batching_window_in_seconds: 0 -> 5

> terraform destroy NÃO foi executado.
---

## 🧪 Teste End-to-End

Endpoint local:

```text
http://localhost:4566/execute-api/932d798a4b/$default
```

Exemplo:

```bash
curl -i -X POST \
  'http://localhost:4566/execute-api/932d798a4b/$default/api/v1/resource' \
  -H 'Content-Type: application/json' \
  -d '{"name":"Evidence Participant","email":"evidence@wizard.local"}'
```

Resposta esperada: HTTP 202 Accepted

---

## 📊 Estado Terraform

- Recursos AWS gerenciados: 22
- Data sources: 5
- Entradas totais no state: 27
- Add: 0
- Change: 1
- Destroy: 0

---

## 📁 Evidências

```text
evidence/
├── phase-01/
├── phase-02/
├── phase-03/
├── phase-04/
└── final/
```

As evidências documentam Terraform, fluxo End-to-End, segurança, WAF, GuardDuty, S3, DLQ, Event Source Mapping e validação final.
---

## ✅ Validação final

```text
Infrastructure preserved: YES
Terraform validation: SUCCESS
Terraform refresh: SUCCESS
Terraform destroy: NOT EXECUTED

AWS resources managed: 22
Data sources: 5
Total Terraform state entries: 27

Plan: 0 add / 1 change / 0 destroy
Floci: HEALTHY
```

---

## 🌐 Repositório

https://github.com/PH536-UI/wizard-hackathon-v2

Branch: main

## 🏆 Wizard Cloud Hackathon 2026

Serverless Cloud Infrastructure · Terraform · AWS · Floci · Security · Resilience
