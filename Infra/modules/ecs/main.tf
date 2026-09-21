# ============================================================
# DATA SOURCES (Hämtar automatiskt den senaste bilden från ECR)
# ============================================================
data "aws_ecr_repository" "gatus_repo" {
  name = "gatus-app-repo"
}

data "aws_ecr_image" "latest_gatus_image" {
  repository_name = data.aws_ecr_repository.gatus_repo.name
  most_recent     = true
}

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

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.task_cpu
  memory = var.task_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  # Describe the container running inside the task
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${data.aws_ecr_repository.gatus_repo.repository_url}:${data.aws_ecr_image.latest_gatus_image.image_tags[0]}"
      essential = true

      # Gatus accepts requests on port 8080
      portMappings = [
        {
          containerPort = var.application_port
          hostPort      = var.application_port
          protocol      = "tcp"
        }
      ]

      # Mount the EFS volume at /data inside the container
      mountPoints = [
        {
          sourceVolume  = var.efs_volume_name
          containerPath = var.efs_container_path
          readOnly      = false
        }
      ]

      # Send container logs to CloudWatch
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

  # ==========================================================
  # EFS TASK VOLUME
  # ==========================================================

  # Attach the EFS file system to the Task Definition
  volume {
    name = var.efs_volume_name

    efs_volume_configuration {
      file_system_id = var.efs_file_system_id
      root_directory = "/"

      # IAM authorization requires encrypted traffic
      transit_encryption = "ENABLED"

      # Use the ECS Task Role when mounting EFS
      authorization_config {
        iam = "ENABLED"
      }
    }
  }
}


# ============================================================
# ECS SERVICE
# ============================================================

# Keep the requested number of Gatus tasks running
resource "aws_ecs_service" "gatus" {
  name = var.ecs_service_name

  cluster          = aws_ecs_cluster.gatus.id
  task_definition  = aws_ecs_task_definition.gatus.arn
  desired_count    = var.desired_task_count
  platform_version = var.fargate_platform_version

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = var.capacity_provider_weight
    base              = var.capacity_provider_base
  }

  # Place the tasks inside the private network
  network_configuration {
    subnets         = values(var.private_subnet_ids)
    security_groups = [var.ecs_security_group_id]

    # The tasks can reach the internet through NAT
    # but cannot receive public IP addresses
    assign_public_ip = false
  }

  # Register the tasks with the ALB Target Group
  load_balancer {
    target_group_arn = var.target_group_arn

    # These must match the container definition
    container_name = var.container_name
    container_port = var.application_port
  }

  tags = {
    Name = var.ecs_service_name
  }
}
