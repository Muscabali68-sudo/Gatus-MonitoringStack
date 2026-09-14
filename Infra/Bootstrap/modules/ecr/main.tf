
resource "aws_ecr_repository" "repository" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete
  # Automatically scan images for vulnerabilities when they are pushed
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Encrypt images stored in the repository
  encryption_configuration {
    encryption_type = var.encryption_type
  }
}


# custom-kms encryption add