# ============================================================
# ECS TASK EXECUTION ROLE VARIABLES
# ============================================================

# Name of the role ECS uses while starting the task
variable "ecs_execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
}


# ============================================================
# ECS TASK ROLE VARIABLES
# ============================================================

# Name of the role used by the running Gatus task
variable "ecs_task_role_name" {
  description = "Name of the ECS Task Role"
  type        = string
}


# ============================================================
# EFS PERMISSION VARIABLES
# ============================================================

# Name of the EFS permission policy
variable "efs_client_policy_name" {
  description = "Name of the EFS client policy attached to the ECS Task Role"
  type        = string
}

# Exact EFS file system the Gatus task can use
variable "efs_file_system_arn" {
  description = "ARN of the EFS file system used by Gatus"
  type        = string
}