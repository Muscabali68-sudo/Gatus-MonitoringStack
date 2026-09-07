# ============================================================
# ALB SECURITY GROUP OUTPUT
# ============================================================

# Make the ALB security group available to the ALB module
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

# ============================================================
# ECS TASK SECURITY GROUP OUTPUT
# ============================================================

# Make the ECS security group available to the ECS module
output "ecs_security_group_id" {
  description = "ID of the ECS task security group"
  value       = aws_security_group.ecs_task.id
}