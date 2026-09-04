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

module "oidc" {
  source = "./modules/oidc"

  url            = var.github_oidc_url
  client_id_list = var.github_oidc_client_id_list
  name_tag       = var.oidc_name_tag

  github_org    = var.github_org
  github_repo   = var.github_repo
  github_branch = var.github_branch

  build_push_role_name   = var.build_push_role_name
  build_push_policy_name = var.build_push_policy_name

  deployment_role_name   = var.deployment_role_name
  deployment_policy_name = var.deployment_policy_name

  # Receive the bucket ARN from the S3 module
  state_bucket_arn = module.s3.bucket_arn

  # Receive the repository ARN from the ECR module
  ecr_repository_arn = module.ecr.repository_arn
}
