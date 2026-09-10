# ============================================================
# EFS OUTPUTS
# ============================================================

# Used by the ECS Task Definition to attach the EFS volume
output "file_system_id" {
  description = "ID of the Gatus EFS file system"
  value       = aws_efs_file_system.gatus.id
}

# Used by the ECS Task Role and EFS file-system policy
output "file_system_arn" {
  description = "ARN of the Gatus EFS file system"
  value       = aws_efs_file_system.gatus.arn
} 