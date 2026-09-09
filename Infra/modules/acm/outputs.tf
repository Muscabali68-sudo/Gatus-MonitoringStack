# Give the validated certificate ARN to the ALB module
output "certificate_arn" {
  description = "ARN of the validated ACM certificate"
  value       = aws_acm_certificate_validation.gatus.certificate_arn
}