# ============================================================
# ECS IAM OUTPUTS
# ============================================================

# The Task Definition uses this as execution_role_arn
output "ecs_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = aws_iam_role.ecs_execution.arn
}

# The Task Definition uses this as task_role_arn
output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = aws_iam_role.ecs_task.arn
}

# The EFS file-system policy can use this role name if needed
output "ecs_task_role_name" {
  description = "Name of the ECS Task Role"
  value       = aws_iam_role.ecs_task.name
}