# ============================================================
# ACM CERTIFICATE
# ============================================================

# Request an HTTPS certificate for the domain
resource "aws_acm_certificate" "gatus" {
  domain_name       = var.domain_name
  validation_method = var.validation_method
  key_algorithm     = var.key_algorithm

  tags = {
    Name = var.certificate_name
  }

  # Create the replacement before deleting an old certificate
  lifecycle {
    create_before_destroy = true
  }
}


# ============================================================
# ACM DNS VALIDATION RECORD
# ============================================================

# ACM provides a DNS record that proves we control the domain
resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for option in aws_acm_certificate.gatus.domain_validation_options :
    option.domain_name => {
      name   = option.resource_record_name
      type   = option.resource_record_type
      record = option.resource_record_value
    }
  }

  # Create the validation record inside our hosted zone
  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = var.validation_record_ttl
  records = [each.value.record]
}


# ============================================================
# ACM CERTIFICATE VALIDATION
# ============================================================

# Wait until ACM finds the DNS record and validates the certificate
resource "aws_acm_certificate_validation" "gatus" {
  certificate_arn = aws_acm_certificate.gatus.arn

  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation :
    record.fqdn
  ]
}