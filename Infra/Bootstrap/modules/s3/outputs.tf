# Returns the ID of the S3 bucket
output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.bucket.id
}


# Returns the ARN of the S3 bucket
output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}