# Output the role ARN used by the build-and-push workflow
output "build_push_role_arn" {
  description = "ARN of the GitHub Actions build-and-push role"
  value       = aws_iam_role.build_push.arn
}


# Output the role ARN used by the deployment workflow
output "deployment_role_arn" {
  description = "ARN of the GitHub Actions deployment role"
  value       = aws_iam_role.deployment.arn
}