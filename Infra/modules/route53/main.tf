# ============================================================
# ROUTE 53 HOSTED ZONE
# ============================================================

# Create public hosted zone
resource "aws_route53_zone" "gatus" {
  name = var.domain_name

  tags = {
    Name = var.hosted_zone_name
  }
}


# Connect the existing registered domain to the hosted zone
resource "aws_route53domains_registered_domain" "gatus" {
  domain_name = var.domain_name

  # Give the registered domain the four hosted-zone name servers
  name_server {
    name = aws_route53_zone.gatus.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.gatus.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.gatus.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.gatus.name_servers[3]
  }
}

resource "aws_route53_record" "gatus_alb" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}