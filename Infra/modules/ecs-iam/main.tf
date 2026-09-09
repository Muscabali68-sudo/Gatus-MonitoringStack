# Get the ID of the AWS account running Terraform
data "aws_caller_identity" "current" {}


# ============================================================
# ECS TRUST POLICY
# ============================================================

# Both IAM roles use the same ECS Tasks trust policy
locals {
  ecs_task_trust_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        # Only the ECS Tasks service can use these roles
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        # Allow ECS tasks to assume the roles
        Action = "sts:AssumeRole"

        # Only allow ECS tasks running in our AWS account
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}


# ============================================================
# ECS TASK EXECUTION ROLE
# ============================================================

# ECS and Fargate use this role when starting the task
resource "aws_iam_role" "ecs_execution" {
  name = var.ecs_execution_role_name

  assume_role_policy = local.ecs_task_trust_policy

  tags = {
    Name = var.ecs_execution_role_name
  }
}

# Allow ECS to pull the image from ECR and send logs to CloudWatch
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role = aws_iam_role.ecs_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ============================================================
# ECS TASK ROLE
# ============================================================

# The running Gatus task uses this role as its AWS identity
resource "aws_iam_role" "ecs_task" {
  name = var.ecs_task_role_name

  assume_role_policy = local.ecs_task_trust_policy

  tags = {
    Name = var.ecs_task_role_name
  }
}


# ============================================================
# EFS CLIENT PERMISSIONS
# ============================================================

# Allow the running Gatus task to mount and write to its EFS
resource "aws_iam_role_policy" "efs_client" {
  name = var.efs_client_policy_name
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ]

        # Only allow access to the Gatus EFS file system
        Resource = var.efs_file_system_arn

        # Require the task to connect through an EFS mount target
        Condition = {
          Bool = {
            "elasticfilesystem:AccessedViaMountTarget" = "true"
          }
        }
      }
    ]
  })
}