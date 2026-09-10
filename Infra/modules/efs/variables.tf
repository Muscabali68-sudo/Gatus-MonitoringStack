# ============================================================
# EFS FILE SYSTEM VARIABLES
# ============================================================

variable "efs_name" {
  description = "Name tag applied to the Gatus EFS file system"
  type        = string
}

variable "efs_creation_token" {
  description = "Unique creation token for the Gatus EFS file system"
  type        = string
}

variable "efs_encrypted" {
  description = "Controls whether EFS data is encrypted at rest"
  type        = bool
}

variable "efs_performance_mode" {
  description = "Performance mode used by the EFS file system"
  type        = string
}

variable "efs_throughput_mode" {
  description = "Throughput mode used by the EFS file system"
  type        = string
}


# ============================================================
# EFS LIFECYCLE VARIABLES
# ============================================================

variable "transition_to_ia" {
  description = "Time before unused files move into Infrequent Access"
  type        = string
}

variable "transition_to_archive" {
  description = "Time before unused files move into Archive storage"
  type        = string
}

variable "transition_to_standard" {
  description = "Controls whether accessed files return to Standard storage"
  type        = string
  nullable    = true
}


# ============================================================
# EFS BACKUP VARIABLES
# ============================================================

variable "enable_automatic_backups" {
  description = "Controls whether automatic EFS backups are enabled"
  type        = bool
}


# ============================================================
# EFS NETWORK VARIABLES
# ============================================================

variable "private_subnet_ids" {
  description = "Private subnet IDs where EFS mount targets are created"
  type        = map(string)
}

variable "efs_security_group_id" {
  description = "Security Group attached to the EFS mount targets"
  type        = string
}