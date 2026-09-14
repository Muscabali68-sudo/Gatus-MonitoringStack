# ============================================================
# VPC VARIABLES
# ============================================================

# CIDR block used by the VPC
variable "vpc_cidr_block" {
  description = "CIDR block used by the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


# Enable DNS resolution inside the VPC
variable "enable_dns_support" {
  description = "Enable DNS support inside the VPC"
  type        = bool
  default     = true
}


# Enable DNS hostnames inside the VPC
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames inside the VPC"
  type        = bool
  default     = true
}


# Name tag applied to the VPC
variable "vpc_name" {
  description = "Name tag applied to the VPC"
  type        = string
  default     = "gatus_vpc"
}


# Public and private subnet configuration
variable "subnets" {
  description = "Public and private subnets"

  type = map(object({
    cidr_block        = string
    availability_zone = string
    public_ip         = bool
  }))

  default = {
    "public-1a" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "eu-central-1a"
      public_ip         = true
    }

    "public-1b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "eu-central-1b"
      public_ip         = true
    }

    "private-1a" = {
      cidr_block        = "10.0.11.0/24"
      availability_zone = "eu-central-1a"
      public_ip         = false
    }

    "private-1b" = {
      cidr_block        = "10.0.12.0/24"
      availability_zone = "eu-central-1b"
      public_ip         = false
    }
  }
}


# Name tag applied to the Internet Gateway
variable "internet_gateway_name" {
  description = "Name tag applied to the Internet Gateway"
  type        = string
  default     = "gatus-internet-gateway"
}

# Name applied to the NAT Gateway
variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "gatus-regional-nat-gateway"
}

# Create the NAT Gateway at VPC level across Availability Zones
variable "availability_mode" {
  description = "Availability mode of the NAT Gateway"
  type        = string
  default     = "regional"
}

# Allow the NAT Gateway to provide internet access
variable "connectivity_type" {
  description = "Connectivity type of the NAT Gateway"
  type        = string
  default     = "public"
}

# Name applied to the public route table
variable "public_route_table_name" {
  description = "Name of the public route table"
  type        = string
  default     = "gatus-public-route-table"
}

# Name applied to the private route table
variable "private_route_table_name" {
  description = "Name of the private route table"
  type        = string
  default     = "gatus-private-route-table"
}

# Send traffic going outside the VPC toward a gateway
variable "route_destination_cidr_block" {
  description = "Destination CIDR block used by the internet routes"
  type        = string
  default     = "0.0.0.0/0"
}

# ============================================================
# SHARED SECURITY GROUP VARIABLES
# ============================================================

# Protocol used by the security group rules
variable "tcp_protocol" {
  description = "TCP protocol used by the security group rules"
  type        = string
  default     = "tcp"
}


# ============================================================
# ALB SECURITY GROUP VARIABLES
# ============================================================

# Name applied to the Gatus ALB security group
variable "alb_security_group_name" {
  description = "Name of the ALB security group"
  type        = string
  default     = "gatus-alb-security-group"
}

# Description applied to the Gatus ALB security group
variable "alb_security_group_description" {
  description = "Description of the ALB security group"
  type        = string
  default     = "Controls traffic for the Gatus Application Load Balancer"
}

# Allow users from anywhere on the internet to reach the ALB
variable "alb_ingress_cidr" {
  description = "IPv4 CIDR block allowed to reach the ALB"
  type        = string
  default     = "0.0.0.0/0"
}

# Port used to redirect HTTP traffic to HTTPS
variable "http_port" {
  description = "Port used for HTTP traffic"
  type        = number
  default     = 80
}

# Port used for secure HTTPS traffic
variable "https_port" {
  description = "Port used for HTTPS traffic"
  type        = number
  default     = 443
}

# Port where the Gatus container receives requests
variable "application_port" {
  description = "Port used by the Gatus application"
  type        = number
  default     = 8080
}

# ============================================================
# ECS TASK SECURITY GROUP VARIABLES
# ============================================================

# Name applied to the Gatus ECS task security group
variable "ecs_security_group_name" {
  description = "Name of the ECS task security group"
  type        = string
  default     = "gatus-ecs-task-security-group"
}
variable "ecs_outbound_cidr" {
  description = "IPv4 CIDR block allowed for ECS outbound traffic"
  type        = string
  default     = "0.0.0.0/0"
}
# Description applied to the Gatus ECS task security group
variable "ecs_security_group_description" {
  description = "Description of the ECS task security group"
  type        = string
  default     = "Controls traffic for the Gatus ECS tasks"
}
# Standard NFS port used by EFS
variable "efs_port" {
  description = "Port used by EFS for NFS traffic"
  type        = number
  default     = 2049
}
# ============================================================
# EFS SECURITY GROUP VARIABLES
# ============================================================

# Name applied to the Gatus EFS security group
variable "efs_security_group_name" {
  description = "Name of the EFS security group"
  type        = string
  default     = "gatus-efs-security-group"
}

# Description applied to the Gatus EFS security group
variable "efs_security_group_description" {
  description = "Description of the EFS security group"
  type        = string
  default     = "Controls traffic to the Gatus EFS file system"
}

# ============================================================
# APPLICATION LOAD BALANCER VARIABLES
# ============================================================

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "gatus-application-load-balancer"
}

# False makes the ALB publicly accessible
variable "alb_internal" {
  description = "Controls whether the ALB is internal or public"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of load balancer"
  type        = string
  default     = "application"
}

# Keep false while regularly creating and destroying the project
variable "enable_deletion_protection" {
  description = "Protects the ALB from accidental deletion"
  type        = bool
  default     = false
}


# ============================================================
# TARGET GROUP VARIABLES
# ============================================================

variable "target_group_name" {
  description = "Name of the Gatus target group"
  type        = string
  default     = "gatus-target-group"
}

# The ALB communicates with Gatus using HTTP inside the VPC
variable "target_group_protocol" {
  description = "Protocol used between the ALB and Gatus"
  type        = string
  default     = "HTTP"
}

# Fargate tasks are registered using their private IP addresses
variable "target_type" {
  description = "Type of targets registered with the target group"
  type        = string
  default     = "ip"
}


# ============================================================
# HEALTH CHECK VARIABLES
# ============================================================

variable "health_check_path" {
  description = "Path used to check the health of Gatus"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP response codes considered healthy"
  type        = string
  default     = "200-399"
}

variable "health_check_interval" {
  description = "Seconds between health checks"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Seconds before a health check times out"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Successful checks required before a target is healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Failed checks required before a target is unhealthy"
  type        = number
  default     = 3
}


# ============================================================
# HTTPS LISTENER VARIABLES
# ============================================================

# AWS currently recommends this TLS policy for general HTTPS use
variable "ssl_policy" {
  description = "TLS security policy used by the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
}

# ============================================================
# DNS VARIABLES
# ============================================================

# Domain that we already own through Route 53
variable "domain_name" {
  description = "Domain name managed by Route 53"
  type        = string
  default     = "muscabali.co.uk"
}

# Name tag applied to the hosted zone
variable "hosted_zone_name" {
  description = "Name tag applied to the Route 53 hosted zone"
  type        = string
  default     = "gatus-public-hosted-zone"
}

# ============================================================
# ACM VARIABLES
# ============================================================

variable "certificate_name" {
  description = "Name tag applied to the ACM certificate"
  type        = string
  default     = "gatus-acm-certificate"
}

# Use DNS records to prove ownership of the domain
variable "validation_method" {
  description = "Method used to validate the ACM certificate"
  type        = string
  default     = "DNS"
}

# Use the widely supported RSA 2048 certificate algorithm
variable "key_algorithm" {
  description = "Key algorithm used by the ACM certificate"
  type        = string
  default     = "RSA_2048"
}


# Allow DNS resolvers to cache the validation record for 300 seconds
variable "validation_record_ttl" {
  description = "TTL for the ACM validation DNS record"
  type        = number
  default     = 300
}

# ============================================================
# ECS IAM VARIABLES
# ============================================================

# Name of the role ECS uses to prepare and start the task
variable "ecs_execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
  default     = "gatus-ecs-task-execution-role"
}

# Name of the role used by the running Gatus application
variable "ecs_task_role_name" {
  description = "Name of the ECS Task Role"
  type        = string
  default     = "gatus-ecs-task-role"
}

# Name of the policy that lets the task use EFS
variable "efs_client_policy_name" {
  description = "Name of the EFS client policy"
  type        = string
  default     = "gatus-efs-client-policy"
}

# ============================================================
# EFS FILE SYSTEM VARIABLES
# ============================================================

variable "efs_name" {
  description = "Name tag applied to the Gatus EFS file system"
  type        = string
  default     = "gatus-efs"
}

variable "efs_creation_token" {
  description = "Unique creation token for the Gatus EFS file system"
  type        = string
  default     = "gatus-efs"
}

variable "efs_encrypted" {
  description = "Controls whether EFS data is encrypted at rest"
  type        = bool
  default     = true
}

variable "efs_performance_mode" {
  description = "Performance mode used by the EFS file system"
  type        = string
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  description = "Throughput mode used by the EFS file system"
  type        = string
  default     = "elastic"
}


# ============================================================
# EFS LIFECYCLE VARIABLES
# ============================================================

variable "efs_transition_to_ia" {
  description = "Time before unused files move into Infrequent Access"
  type        = string
  default     = "AFTER_30_DAYS"
}

variable "efs_transition_to_archive" {
  description = "Time before unused files move into Archive storage"
  type        = string
  default     = "AFTER_90_DAYS"
}

# Null matches the Console selection: Transition into Standard = None
variable "efs_transition_to_standard" {
  description = "Controls whether accessed files return to Standard storage"
  type        = string
  default     = null
}


# ============================================================
# EFS BACKUP VARIABLES
# ============================================================

variable "efs_enable_automatic_backups" {
  description = "Controls whether automatic EFS backups are enabled"
  type        = bool
  default     = true
}


# ============================================================
# ECS CLUSTER VARIABLES
# ============================================================

variable "ecs_cluster_name" {
  description = "Name of the Gatus ECS cluster"
  type        = string
  default     = "gatusapp-cluster"
}


# ============================================================
# CLOUDWATCH LOG VARIABLES
# ============================================================

# Reuse this variable if it already exists in the root
variable "aws_region" {
  description = "AWS Region where the infrastructure is created"
  type        = string
  default     = "eu-central-1"
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for Gatus"
  type        = string
  default     = "/ecs/gatus"
}

variable "log_retention_days" {
  description = "Number of days that Gatus logs are stored"
  type        = number
  default     = 30
}

variable "log_stream_prefix" {
  description = "Prefix used for Gatus CloudWatch log streams"
  type        = string
  default     = "ecs"
}


# ============================================================
# TASK DEFINITION VARIABLES
# ============================================================

variable "task_definition_family" {
  description = "Family name of the Gatus Task Definition"
  type        = string
  default     = "gatus-task"
}

variable "task_cpu" {
  description = "CPU units allocated to the Gatus task"
  type        = string
  default     = "1024"
}

variable "task_memory" {
  description = "Memory allocated to the Gatus task in MiB"
  type        = string
  default     = "3072"
}

variable "operating_system_family" {
  description = "Operating system used by the Gatus task"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "CPU architecture used by the Gatus task"
  type        = string
  default     = "ARM64"
}


# ============================================================
# CONTAINER VARIABLES
# ============================================================

variable "container_name" {
  description = "Name of the Gatus container"
  type        = string
  default     = "Main"
}


# The ECR repository was created by the bootstrap infrastructure
variable "ecr_repository_name" {
  description = "Name of the ECR repository containing the Gatus image"
  type        = string
  default     = "gatus-app-repo"
}

variable "container_image_tag" {
  description = "Tag of the Gatus container image"
  type        = string
  default     = "test-v1"
}


# ============================================================
# EFS VOLUME VARIABLES
# ============================================================

variable "efs_volume_name" {
  description = "Name of the EFS volume in the Task Definition"
  type        = string
  default     = "gatus-data"
}

variable "efs_container_path" {
  description = "Path where EFS is mounted inside the Gatus container"
  type        = string
  default     = "/data"
}


# ============================================================
# ECS SERVICE VARIABLES
# ============================================================

variable "ecs_service_name" {
  description = "Name of the Gatus ECS service"
  type        = string
  default     = "service-gatus"
}

variable "desired_task_count" {
  description = "Number of Gatus tasks the ECS service keeps running"
  type        = number
  default     = 1
}

variable "fargate_platform_version" {
  description = "Fargate platform version used by the service"
  type        = string
  default     = "1.4.0"
}

variable "capacity_provider" {
  description = "Capacity provider used by the ECS service"
  type        = string
  default     = "FARGATE"
}

variable "capacity_provider_weight" {
  description = "Relative percentage of tasks assigned to this capacity provider"
  type        = number
  default     = 1
}

variable "capacity_provider_base" {
  description = "Minimum number of tasks assigned to this capacity provider"
  type        = number
  default     = 0
}