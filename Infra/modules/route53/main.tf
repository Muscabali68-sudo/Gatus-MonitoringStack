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

# ============================================================
# ALB ALIAS RECORD
# ============================================================

# Point the domain to the Application Load Balancer
resource "aws_route53_record" "gatus_alb" {
  # Create the record inside the hosted zone created above
  zone_id = aws_route53_zone.gatus.zone_id

  name = var.domain_name
  type = "A"

  # AWS handles the changing ALB IP addresses for us
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}