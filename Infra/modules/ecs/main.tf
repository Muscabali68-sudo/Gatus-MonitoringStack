# ============================================================
# ECS CLUSTER
# ============================================================

# Create the ECS cluster that will contain the Gatus service
resource "aws_ecs_cluster" "gatus" {
  name = var.ecs_cluster_name

  tags = {
    Name = var.ecs_cluster_name
  }
}

# ============================================================
# CLOUDWATCH LOG GROUP
# ============================================================

# Create the CloudWatch location where Gatus logs will be stored
resource "aws_cloudwatch_log_group" "gatus" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.log_retention_days

  tags = {
    Name = var.cloudwatch_log_group_name
  }
}

# ============================================================
# ECS TASK DEFINITION
# ============================================================

# Define how ECS should run the Gatus container
resource "aws_ecs_task_definition" "gatus" {
  family = var.task_definition_family

  # Fargate tasks must use the awsvpc network mode
  network_mode = "awsvpc"

  # Tell ECS that this task will run on Fargate
  requires_compatibilities = ["FARGATE"]

  # Total CPU and memory available to the task
  cpu    = var.task_cpu
  memory = var.task_memory

  # ECS uses this role when preparing and starting the task
  execution_role_arn = var.execution_role_arn

  # The running Gatus container uses this role
  task_role_arn = var.task_role_arn

  # Match the ARM64 container image used in the ClickOps setup
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  # Describe the container that should run inside the task
container_definitions = jsonencode([
  {
    name      = var.container_name
    image     = var.container_image
    essential = true

    # Gatus accepts requests on port 8080
    portMappings = [
      {
        containerPort = var.application_port
        hostPort      = var.application_port
        protocol      = "tcp"
      }
    ]

    # Send the Gatus container logs to CloudWatch
    logConfiguration = {
      logDriver = "awslogs"

      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.gatus.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = var.log_stream_prefix
      }
    }
  }
])

# ============================================================
# EFS TASK VOLUME
# ============================================================

volume {
  name = var.efs_volume_name

  efs_volume_configuration {
    file_system_id = var.efs_file_system_id

    # Mount the root of this dedicated Gatus file system
    root_directory = "/"

    # IAM authorization requires transit encryption
    transit_encryption = "ENABLED"

    # Use the ECS Task Role when mounting EFS
    authorization_config {
      iam = "ENABLED"
    }
  }
} 

# ======================================================
# GATUS EFS CONTAINER MOUNT
# ======================================================

# Mount the EFS task volume inside the main Gatus container
mountPoints = [
  {
    # Must match the name in the volume block
    sourceVolume = var.efs_volume_name

    # Location where EFS appears inside the container
    containerPath = var.efs_container_path

    # Gatus needs permission to write persistent data
    readOnly = false
  }
] 

# ============================================================
# ECS SERVICE
# ============================================================

# Keep the requested number of Gatus Fargate tasks running
resource "aws_ecs_service" "gatus" {
  name = var.ecs_service_name

  # Place the service inside the Gatus ECS cluster
  cluster = aws_ecs_cluster.gatus.id

  # Tell the service which task blueprint to run
  task_definition = aws_ecs_task_definition.gatus.arn

  # Control how many Gatus tasks should run
  desired_count = var.desired_task_count

  # Use the same Fargate platform version as the ClickOps setup
  platform_version = var.fargate_platform_version

  # Run the tasks using the Fargate capacity provider
  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = var.capacity_provider_weight
    base              = var.capacity_provider_base
  }

  # ==========================================================
  # ECS SERVICE NETWORKING
  # ==========================================================

  network_configuration {
    # Place the Fargate tasks in both private subnets
    subnets = values(var.private_subnet_ids)

    # Protect the tasks with the ECS Task Security Group
    security_groups = [var.ecs_security_group_id]

    # Keep the tasks private without public IP addresses
    assign_public_ip = false
  }

  tags = {
    Name = var.ecs_service_name
  }
} 

  # ==========================================================
  # ECS SERVICE LOAD BALANCER
  # ==========================================================

  # Register the Gatus tasks with the ALB Target Group
  load_balancer {
    target_group_arn = var.target_group_arn

    # These must match the Task Definition container
    container_name = var.container_name
    container_port = var.application_port
  }

  tags = {
    Name = var.ecs_service_name
  }
}
