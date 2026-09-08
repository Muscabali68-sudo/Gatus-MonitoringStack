# ============================================================
# LOAD BALANCER OUTPUTS
# ============================================================

# Make the ALB ARN available to other modules
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.gatus_alb.arn
}

# Used by Route 53 to send the domain to the ALB
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.gatus_alb.dns_name
}

# Used when creating a Route 53 alias record
output "alb_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.gatus_alb.zone_id
}


# ============================================================
# TARGET GROUP OUTPUT
# ============================================================

# Used by the ECS service to register the Fargate tasks
output "target_group_arn" {
  description = "ARN of the Gatus target group"
  value       = aws_lb_target_group.gatus_target_group.arn
} 