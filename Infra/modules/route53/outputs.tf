# ACM will later use this ID to create its validation record
output "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.gatus.zone_id
}

# These name servers must be connected to the registered domain
output "name_servers" {
  description = "Name servers assigned to the hosted zone"
  value       = aws_route53_zone.gatus.name_servers
}

# Final domain pointing to the ALB
output "domain_name" {
  description = "Domain name connected to the ALB"
  value       = aws_route53_record.gatus_alb.fqdn
}
