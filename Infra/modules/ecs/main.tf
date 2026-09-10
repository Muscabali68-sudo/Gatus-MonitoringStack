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

