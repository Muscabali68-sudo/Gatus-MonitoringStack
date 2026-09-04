variable "github_org" {
  description = "GitHub organization or username that owns the repository"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the IAM roles"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the IAM roles"
  type        = string
  default     = "main"
}

variable "build_push_role_name" {
  description = "IAM role used by the GitHub Actions build and push workflow"
  type        = string
}

variable "build_push_policy_name" {
  description = "IAM policy used by the GitHub Actions build and push role"
  type        = string
}

variable "deployment_role_name" {
  description = "IAM role used by the GitHub Actions Terraform deployment workflow"
  type        = string
}

variable "deployment_policy_name" {
  description = "IAM policy used by the GitHub Actions Terraform deployment role"
  type        = string
}

