# ============================================================
# NETWORK INPUTS
# ============================================================

# VPC where the target group will be created
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# Public subnets where the ALB will run
variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

# Security group attached to the ALB
variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}


# ============================================================
# LOAD BALANCER VARIABLES
# ============================================================

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "alb_internal" {
  description = "Controls whether the ALB is internal or public"
  type        = bool
}

variable "load_balancer_type" {
  description = "Type of load balancer"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Protects the ALB from accidental deletion"
  type        = bool
}


# ============================================================
# TARGET GROUP VARIABLES
# ============================================================

variable "target_group_name" {
  description = "Name of the Gatus target group"
  type        = string
}

variable "application_port" {
  description = "Port used by the Gatus application"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol used between the ALB and Gatus"
  type        = string
}

variable "target_type" {
  description = "Type of targets registered with the target group"
  type        = string
}


# ============================================================
# HEALTH CHECK VARIABLES
# ============================================================

variable "health_check_path" {
  description = "Path used to check the health of Gatus"
  type        = string
}

variable "health_check_matcher" {
  description = "HTTP response codes considered healthy"
  type        = string
}

variable "health_check_interval" {
  description = "Seconds between health checks"
  type        = number
}

variable "health_check_timeout" {
  description = "Seconds before a health check times out"
  type        = number
}

variable "healthy_threshold" {
  description = "Successful checks required before a target is healthy"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Failed checks required before a target is unhealthy"
  type        = number
}


# ============================================================
# LISTENER VARIABLES
# ============================================================

variable "http_port" {
  description = "Port used for HTTP redirection"
  type        = number
}

variable "https_port" {
  description = "Port used for HTTPS traffic"
  type        = number
}

variable "ssl_policy" {
  description = "TLS security policy used by the HTTPS listener"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate used by the HTTPS listener"
  type        = string
}