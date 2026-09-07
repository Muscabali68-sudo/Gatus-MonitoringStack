# ============================================================
# SHARED VARIABLES
# ============================================================

# VPC where the security groups will be created
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# Protocol used by the security group rules
variable "tcp_protocol" {
  description = "TCP protocol used by the security group rules"
  type        = string
}


# ============================================================
# ALB SECURITY GROUP VARIABLES
# ============================================================

# Name applied to the ALB security group
variable "alb_security_group_name" {
  description = "Name of the ALB security group"
  type        = string
}

# Description applied to the ALB security group
variable "alb_security_group_description" {
  description = "Description of the ALB security group"
  type        = string
}

# IPv4 addresses allowed to reach the public ALB
variable "alb_ingress_cidr" {
  description = "IPv4 CIDR block allowed to reach the ALB"
  type        = string
}

# Port used for HTTP redirection
variable "http_port" {
  description = "Port used for HTTP traffic"
  type        = number
}

# Port used for secure HTTPS traffic
variable "https_port" {
  description = "Port used for HTTPS traffic"
  type        = number
}

# Port used by the Gatus application
variable "application_port" {
  description = "Port used by the Gatus application"
  type        = number
}

# ============================================================
# ECS TASK SECURITY GROUP VARIABLES
# ============================================================

# Name applied to the ECS task security group
variable "ecs_security_group_name" {
  description = "Name of the ECS task security group"
  type        = string
}

# Description applied to the ECS task security group
variable "ecs_security_group_description" {
  description = "Description of the ECS task security group"
  type        = string
}
# Port used by EFS for NFS connections
variable "efs_port" {
  description = "Port used by EFS for NFS traffic"
  type        = number
}

# ============================================================
# EFS SECURITY GROUP VARIABLES
# ============================================================

# Name applied to the EFS security group
variable "efs_security_group_name" {
  description = "Name of the EFS security group"
  type        = string
}

# Description applied to the EFS security group
variable "efs_security_group_description" {
  description = "Description of the EFS security group"
  type        = string
}