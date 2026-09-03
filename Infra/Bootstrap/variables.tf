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