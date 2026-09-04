# GitHub's OIDC provider URL
variable "url" {
  description = "URL of the GitHub Actions OIDC provider"
  type        = string
}


# The service allowed to receive the GitHub token
variable "client_id_list" {
  description = "Audience allowed to use the GitHub OIDC provider"
  type        = list(string)
}


# Name tag for the OIDC provider
variable "name_tag" {
  description = "Name tag for the GitHub OIDC provider"
  type        = string
}


# Name of the IAM role used to push images
variable "build_push_role_name" {
  description = "Name of the GitHub Actions build-and-push role"
  type        = string
}


# Name of the ECR permissions policy
variable "build_push_policy_name" {
  description = "Name of the build-and-push permissions policy"
  type        = string
}


# Name of the IAM role used to deploy the infrastructure
variable "deployment_role_name" {
  description = "Name of the GitHub Actions deployment role"
  type        = string
}


# Name of the deployment permissions policy
variable "deployment_policy_name" {
  description = "Name of the deployment permissions policy"
  type        = string
}


# GitHub organization or username that owns the repository
variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}


# Repository containing the GitHub Actions workflows
variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}


# Branch allowed to use the AWS roles
variable "github_branch" {
  description = "GitHub branch name"
  type        = string
}


# ECR repository where GitHub Actions pushes the image
variable "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  type        = string
}


# S3 bucket containing the Terraform state
variable "state_bucket_arn" {
  description = "ARN of the S3 Terraform state bucket"
  type        = string
}


