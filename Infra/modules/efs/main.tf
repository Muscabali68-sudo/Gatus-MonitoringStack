# ============================================================
# EFS FILE SYSTEM
# ============================================================

# Create persistent storage for the Gatus application
resource "aws_efs_file_system" "gatus" {
  creation_token = var.efs_creation_token

  # Not setting availability_zone_name creates a Regional file system
  # The data is stored across multiple Availability Zones

  # Encrypt stored data using the default AWS-managed EFS KMS key
  encrypted = var.efs_encrypted

  # General Purpose works with Elastic throughput and Archive storage
  performance_mode = var.efs_performance_mode

  # Automatically scale throughput based on the workload
  throughput_mode = var.efs_throughput_mode

  # Move unused files to Infrequent Access
  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }

  # Move older unused files to Archive
  lifecycle_policy {
    transition_to_archive = var.transition_to_archive
  }

  # Skip this rule when the value is null
  dynamic "lifecycle_policy" {
    for_each = var.transition_to_standard == null ? [] : [var.transition_to_standard]

    content {
      transition_to_primary_storage_class = lifecycle_policy.value
    }
  }

  tags = {
    Name = var.efs_name
  }
}


# ============================================================
# EFS AUTOMATIC BACKUPS
# ============================================================

# Enable or disable automatic EFS backups through AWS Backup
resource "aws_efs_backup_policy" "gatus" {
  file_system_id = aws_efs_file_system.gatus.id

  backup_policy {
    status = var.enable_automatic_backups ? "ENABLED" : "DISABLED"
  }
}


# ============================================================
# EFS MOUNT TARGETS
# ============================================================

# Create one EFS network connection in each private subnet
resource "aws_efs_mount_target" "gatus" {
  for_each = var.private_subnet_ids

  # Connect the mount target to the Gatus file system
  file_system_id = aws_efs_file_system.gatus.id

  # Place the current mount target in the current private subnet
  subnet_id = each.value

  # Protect the mount target with the EFS Security Group
  security_groups = [var.efs_security_group_id]
}