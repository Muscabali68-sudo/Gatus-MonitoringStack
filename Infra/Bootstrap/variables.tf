# Name of the S3 bucket
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "gatus-bootstrap-terraform-state"
}

# Name tag applied to the S3 bucket
variable "name_tag" {
  description = "Name tag applied to the S3 bucket"
  type        = string
  default     = "Bootstrap_State"
}

# Controls whether S3 bucket versioning is enabled
variable "enable_versioning" {
  description = "Status of S3 bucket versioning"
  type        = string
  default     = "Enabled"
}

# Controls the server-side encryption algorithm
variable "sse_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
  default     = "AES256"
}

# Controls object ownership for the bucket
variable "object_ownership" {
  description = "S3 bucket object ownership setting"
  type        = string
  default     = "BucketOwnerEnforced"
}

# ============================================================
# ECR VARIABLES
# ============================================================

# Name of the ECR repository
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "gatus-app-repo"
}

# Controls whether image tags can be overwritten
variable "ecr_image_tag_mutability" {
  description = "Controls whether ECR image tags can be overwritten"
  type        = string
  default     = "IMMUTABLE"
}

# Controls whether images are automatically scanned when pushed
variable "ecr_scan_on_push" {
  description = "Enable automatic vulnerability scanning when images are pushed"
  type        = bool
  default     = true
}

# Controls how images in the ECR repository are encrypted
variable "ecr_encryption_type" {
  description = "Encryption type used for images in the ECR repository"
  type        = string
  default     = "AES256"
}


# ============================================================
# OIDC VARIABLES
# ============================================================

# GitHub OIDC provider URL
variable "github_oidc_url" {
  description = "URL of the GitHub Actions OIDC provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}


# AWS STS is the intended receiver of the GitHub token
variable "github_oidc_client_id_list" {
  description = "Audience accepted by AWS for GitHub OIDC tokens"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}


# Name tag for the GitHub OIDC provider
variable "oidc_name_tag" {
  description = "Name tag applied to the GitHub OIDC provider"
  type        = string
  default     = "GitHub_Actions_OIDC"
}


# GitHub username or organization that owns the repository
variable "github_org" {
  description = "GitHub username or organization"
  type        = string
  default     = "Muscabali68-sudo"
}


# GitHub repository allowed to use the IAM roles
variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "Gatus-MonitoringStack"
}


# GitHub branch allowed to use the IAM roles
variable "github_branch" {
  description = "GitHub branch name"
  type        = string
  default     = "main"
}


# Name of the build-and-push IAM role
variable "build_push_role_name" {
  description = "Name of the GitHub Actions build-and-push role"
  type        = string
  default     = "github-actions-build-push-role"
}


# Name of the build-and-push permissions policy
variable "build_push_policy_name" {
  description = "Name of the build-and-push permissions policy"
  type        = string
  default     = "github-actions-build-push-policy"
}


# Name of the deployment IAM role
variable "deployment_role_name" {
  description = "Name of the GitHub Actions deployment role"
  type        = string
  default     = "github-actions-deployment-role"
}


# Name of the deployment permissions policy
variable "deployment_policy_name" {
  description = "Name of the deployment permissions policy"
  type        = string
  default     = "github-actions-deployment-policy"
}