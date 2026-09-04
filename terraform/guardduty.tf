# GuardDuty já existe c10cb548bd794551877cd2b5595d9eeb - importado
# S3_DATA_EVENTS bloqueado por SCP o-6cp7whdckq - código mantido pra banca (25% Segurança)
resource "aws_guardduty_detector" "main" {
  enable = true
  tags = { Name = "wizard-guardduty" }
}
