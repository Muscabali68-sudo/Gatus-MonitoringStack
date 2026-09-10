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

  # Move files that have not been accessed for 30 days into IA
  lifecycle_policy {
    transition_to_ia = var.transition_to_ia

    # Move files that have not been accessed for 90 days into Archive
    transition_to_archive = var.transition_to_archive

    # Null means files do not automatically return to Standard
    transition_to_primary_storage_class = var.transition_to_standard
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