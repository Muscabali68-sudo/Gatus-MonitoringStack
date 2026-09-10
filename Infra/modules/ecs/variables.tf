# ============================================================
# ECS CLUSTER VARIABLES
# ============================================================

variable "ecs_cluster_name" {
  description = "Name of the Gatus ECS cluster"
  type        = string
}


# ============================================================
# CLOUDWATCH LOG VARIABLES
# ============================================================

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for Gatus"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days that Gatus logs are stored"
  type        = number
}

variable "aws_region" {
  description = "AWS Region where the Gatus infrastructure runs"
  type        = string
}

variable "log_stream_prefix" {
  description = "Prefix used for the Gatus CloudWatch log streams"
  type        = string
}


# ============================================================
# TASK DEFINITION VARIABLES
# ============================================================

variable "task_definition_family" {
  description = "Family name of the Gatus Task Definition"
  type        = string
}

variable "task_cpu" {
  description = "CPU units allocated to the Gatus Fargate task"
  type        = string
}

variable "task_memory" {
  description = "Memory allocated to the Gatus Fargate task in MiB"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS Task Role used by Gatus"
  type        = string
}

variable "operating_system_family" {
  description = "Operating system used by the Gatus task"
  type        = string
}

variable "cpu_architecture" {
  description = "CPU architecture used by the Gatus task"
  type        = string
}


# ============================================================
# CONTAINER VARIABLES
# ============================================================

variable "container_name" {
  description = "Name of the Gatus container"
  type        = string
}

variable "container_image" {
  description = "Full ECR image address used by the Gatus container"
  type        = string
}

variable "application_port" {
  description = "Port used by the Gatus application"
  type        = number
}


# ============================================================
# EFS VOLUME VARIABLES
# ============================================================

variable "efs_volume_name" {
  description = "Name of the EFS volume in the Task Definition"
  type        = string
}

variable "efs_file_system_id" {
  description = "ID of the EFS file system mounted by Gatus"
  type        = string
}

variable "efs_container_path" {
  description = "Path where EFS is mounted inside the Gatus container"
  type        = string
}


# ============================================================
# ECS SERVICE VARIABLES
# ============================================================

variable "ecs_service_name" {
  description = "Name of the Gatus ECS service"
  type        = string
}

variable "desired_task_count" {
  description = "Number of Gatus tasks the ECS service keeps running"
  type        = number
}

variable "fargate_platform_version" {
  description = "Fargate platform version used by the ECS service"
  type        = string
}

variable "capacity_provider" {
  description = "Capacity provider used to run the ECS tasks"
  type        = string
}

variable "capacity_provider_weight" {
  description = "Relative percentage of tasks assigned to the capacity provider"
  type        = number
}

variable "capacity_provider_base" {
  description = "Minimum number of tasks assigned to the capacity provider"
  type        = number
}


# ============================================================
# ECS SERVICE NETWORK VARIABLES
# ============================================================

variable "private_subnet_ids" {
  description = "Private subnet IDs where the Fargate tasks run"
  type        = map(string)
}

variable "ecs_security_group_id" {
  description = "Security Group attached to the Fargate tasks"
  type        = string
}


# ============================================================
# LOAD BALANCER VARIABLES
# ============================================================

variable "target_group_arn" {
  description = "ARN of the ALB Target Group used by the ECS service"
  type        = string
} 