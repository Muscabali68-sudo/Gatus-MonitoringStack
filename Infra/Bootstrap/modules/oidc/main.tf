# Create the GitHub Actions OIDC provider in AWS
resource "aws_iam_openid_connect_provider" "github_actions" {
  # URL of GitHub's OIDC identity provider
  url = var.url

  # Audience that GitHub Actions tokens are intended for
  client_id_list = var.client_id_list

  # Certificate thumbprint used to establish trust with GitHub
  thumbprint_list = var.thumbprint_list

  # Tags used to identify and manage the resource
  tags = {
    Service   = var.service_tag
    ManagedBy = var.managed_by_tag
  }
}

#Create iam roles on for the depolyment one and one for the build&push yml


#Iam role for build&push yml
#Create premison police for the build&push yml iam role







# Create Iam role for the deployment yml
# Create trust policy=how can use this i am role
# Permissions for the GitHub Actions deployment role
resource "aws_iam_role_policy" "deployment" {
  name = var.deployment_policy_name
  role = aws_iam_role.deployment.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          # VPC, subnets, route tables, NAT Gateway,
          # Internet Gateway and security groups
          "ec2:*",

          # ECS and Fargate
          "ecs:*",

          # Application Load Balancer
          "elasticloadbalancing:*",

          # EFS
          "elasticfilesystem:*",

          # CloudWatch Logs
          "logs:*",

          # ACM certificates
          "acm:*",

          # Route 53 DNS
          "route53:*",

          # IAM roles required by ECS
          "iam:*"
        ]

        Resource = "*"   # specilicera
      }
    ]
  })
}