# Wizard Hackathon 2026 - Como rodar remoto

## Ferramenta escolhida: Discord + tmate
- **Discord**: tela + voz - sem lag, grava a demo
- **tmate**: terminal compartilhado - time digita junto

## Setup 2 comandos
git clone https://github.com/PH536-UI/wizard-hackathon-v2.git
cd wizard-hackathon-v2 && docker compose up -d && ./scripts/demo-equipe.sh

## Validação que a banca quer ver
- Floci HEALTHY em localhost:4566
- 22 recursos AWS emulados
- E2E: 202 Accepted -> SQS 0 msg -> DynamoDB lead gravado
- Segurança: WAF rate 100/300s + GuardDuty ENABLED + S3 Block Public
- Resiliência: DLQ max 3 + ESM Batch 10 Window 5s

## AWS Real (1 flag)
terraform apply -var='use_local_emulator=false'
