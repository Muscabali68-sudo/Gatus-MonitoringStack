# Name of the ECR repository
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

# Controls whether image tags can be overwritten
variable "image_tag_mutability" {
  description = "Controls whether image tags can be overwritten"
  type        = string
}

# Controls whether images are automatically scanned when pushed
variable "scan_on_push" {
  description = "Enable automatic vulnerability scanning when images are pushed"
  type        = bool
}

# Controls how images in the repository are encrypted
variable "encryption_type" {
  description = "Encryption type used for images in the ECR repository"
  type        = string
}