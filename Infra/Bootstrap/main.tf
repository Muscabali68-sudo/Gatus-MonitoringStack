module "s3" {
  source = "./modules/s3"

  bucket_name       = var.bucket_name
  name_tag          = var.name_tag
  enable_versioning = var.enable_versioning
  sse_algorithm     = var.sse_algorithm
  object_ownership  = var.object_ownership
}

module "ecr" {
  source = "./modules/ecr"

  repository_name      = var.ecr_repository_name
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
  encryption_type      = var.ecr_encryption_type
}