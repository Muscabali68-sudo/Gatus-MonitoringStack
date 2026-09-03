# Name of the S3 bucket
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# Name tag applied to the S3 bucket
variable "name_tag" {
  description = "Name tag applied to the S3 bucket"
  type        = string
}

# Controls whether S3 bucket versioning is enabled
variable "enable_versioning" {
  description = "Status of S3 bucket versioning"
  type        = string
}

# Controls the server-side encryption algorithm
variable "sse_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
}

# Controls object ownership for the bucket
variable "object_ownership" {
  description = "S3 bucket object ownership setting"
  type        = string
}

