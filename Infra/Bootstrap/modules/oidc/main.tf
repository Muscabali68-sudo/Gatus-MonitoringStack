# ============================================================
# GITHUB OIDC PROVIDER
# Creates the connection between GitHub Actions and AWS
# ============================================================

resource "aws_iam_openid_connect_provider" "github_actions" {
  # GitHub: "This is where my OIDC tokens come from."
  url = var.url

  # AWS: "The token must be created for AWS STS."
  client_id_list = var.client_id_list

  tags = {
    Name = var.name_tag
  }
}


# ============================================================
# BUILD AND PUSH ROLE
# Used by GitHub Actions to push Docker images to ECR
# ============================================================

resource "aws_iam_role" "build_push" {
  name = var.build_push_role_name

  # Trust policy: Who is allowed to use this role?
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        # AWS: "I trust tokens from this GitHub OIDC provider."
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }

        # GitHub: "Give me temporary AWS credentials for this role."
        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            # AWS: "The token must be created for AWS STS."
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            # AWS: "The token must come from this repository and branch."
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
          }
        }
      }
    ]
  })
}


# Permissions policy: What can the build-and-push role do?
resource "aws_iam_role_policy" "build_push" {
  name = var.build_push_policy_name
  role = aws_iam_role.build_push.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        # GitHub Actions: "Let me log in to Amazon ECR."
        Action = [
          "ecr:GetAuthorizationToken"
        ]

        # AWS requires "*" for the ECR login token
        Resource = "*"
      },
      {
        Effect = "Allow"

        # GitHub Actions: "Let me upload the Docker image layers."
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        # AWS: "You can only push to this ECR repository."
        Resource = var.ecr_repository_arn
      }
    ]
  })
}


# ============================================================
# DEPLOYMENT ROLE
# Used by GitHub Actions to run Terraform
# ============================================================

resource "aws_iam_role" "deployment" {
  name = var.deployment_role_name

  # Trust policy: Who is allowed to use this role?
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        # AWS: "I trust tokens from this GitHub OIDC provider."
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }

        # GitHub: "Give me temporary AWS credentials for this role."
        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            # AWS: "The token must be created for AWS STS."
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            # AWS: "The token must come from this repository and branch."
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
          }
        }
      }
    ]
  })
}


# Permissions policy: What can the deployment role do?
resource "aws_iam_role_policy" "deployment" {
  name = var.deployment_policy_name
  role = aws_iam_role.deployment.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        # Terraform: "Let me create and manage the infrastructure."
        Action = [
          "ec2:*",
          "ecs:*",
          "elasticloadbalancing:*",
          "elasticfilesystem:*",
          "logs:*",
          "acm:*",
          "route53:*"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        # Terraform: "Let me see the state bucket."
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        # This permission applies to the bucket itself
        Resource = var.state_bucket_arn
      },
      {
        Effect = "Allow"

        # Terraform: "Let me read and update the infrastructure state."
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        # AWS: "You can only access state inside infra/."
        Resource = "${var.state_bucket_arn}/infra/*"
      },
      {
        Effect = "Allow"

        # Terraform: "Let me create and manage the IAM roles used by ECS."
        Action = [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:DeleteRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:PutRolePolicy",
          "iam:GetRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:PassRole"
        ]

        Resource = "*"
      }
    ]
  })
}
