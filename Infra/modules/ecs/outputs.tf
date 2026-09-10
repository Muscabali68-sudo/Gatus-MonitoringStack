# ============================================================
# ECS CLUSTER OUTPUTS
# ============================================================

# Useful for deployment workflows and future monitoring
output "cluster_name" {
  description = "Name of the Gatus ECS cluster"
  value       = aws_ecs_cluster.gatus.name
}


# ============================================================
# ECS TASK DEFINITION OUTPUTS
# ============================================================

# Returns the ARN of the current Task Definition revision
output "task_definition_arn" {
  description = "ARN of the Gatus ECS Task Definition"
  value       = aws_ecs_task_definition.gatus.arn
}


# ============================================================
# ECS SERVICE OUTPUTS
# ============================================================

# Useful for deployment workflows and future monitoring
output "service_name" {
  description = "Name of the Gatus ECS service"
  value       = aws_ecs_service.gatus.name
}