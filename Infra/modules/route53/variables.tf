# The registered domain that this hosted zone manages
variable "domain_name" {
  description = "Domain name managed by the Route 53 hosted zone"
  type        = string
}

# Name tag applied to the hosted zone
variable "hosted_zone_name" {
  description = "Name tag applied to the Route 53 hosted zone"
  type        = string
}

# AWS-generated DNS address of the ALB
variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

# Route 53 zone ID belonging to the ALB
variable "alb_zone_id" {
  description = "Route 53 zone ID of the Application Load Balancer"
  type        = string
}