# ============================================================
# VPC MODULE
# ============================================================

# Create the VPC, subnets, gateways and route tables
module "vpc" {
  source = "./modules/vpc"

  # VPC settings
  vpc_name             = var.vpc_name
  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  # Public and private subnet settings
  subnets = var.subnets

  # Internet Gateway and NAT Gateway settings
  internet_gateway_name = var.internet_gateway_name
  nat_gateway_name      = var.nat_gateway_name
  availability_mode     = var.availability_mode
  connectivity_type     = var.connectivity_type

  # Public and private routing settings
  public_route_table_name      = var.public_route_table_name
  private_route_table_name     = var.private_route_table_name
  route_destination_cidr_block = var.route_destination_cidr_block
}

# ============================================================
# SECURITY GROUP MODULE
# ============================================================

# Create the security groups protecting the ALB, ECS and EFS
module "sg" {
  source = "./modules/sg"

  # Create every security group inside the Gatus VPC
  vpc_id = module.vpc.vpc_id

  # Protocol shared by the security group rules
  tcp_protocol = var.tcp_protocol

  # ALB security group settings
  alb_security_group_name        = var.alb_security_group_name
  alb_security_group_description = var.alb_security_group_description
  alb_ingress_cidr               = var.alb_ingress_cidr
  http_port                      = var.http_port
  https_port                     = var.https_port
  application_port               = var.application_port

  # ECS task security group settings
  ecs_security_group_name        = var.ecs_security_group_name
  ecs_security_group_description = var.ecs_security_group_description
  ecs_outbound_cidr              = var.ecs_outbound_cidr

  # EFS security group settings
  efs_security_group_name        = var.efs_security_group_name
  efs_security_group_description = var.efs_security_group_description
  efs_port                       = var.efs_port
}

# ============================================================
# ROUTE 53 MODULE
# ============================================================

# Create the hosted zone, connect the registered domain
# and point the domain to the ALB
module "route53" {
  source = "./modules/route53"

  # Route 53 Domains operations are handled through us-east-1
  providers = {
    aws = aws.us_east_1
  }

  # Domain and hosted-zone settings
  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name

  # Connect the domain record to the ALB created by Terraform
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

# ============================================================
# EFS MODULE
# ============================================================

# Create persistent storage for the Gatus application
module "efs" {
  source = "./modules/efs"

  # EFS file-system settings
  efs_name             = var.efs_name
  efs_creation_token   = var.efs_creation_token
  efs_encrypted        = var.efs_encrypted
  efs_performance_mode = var.efs_performance_mode
  efs_throughput_mode  = var.efs_throughput_mode

  # EFS lifecycle settings
  transition_to_ia       = var.efs_transition_to_ia
  transition_to_archive  = var.efs_transition_to_archive
  transition_to_standard = var.efs_transition_to_standard

  # EFS backup setting
  enable_automatic_backups = var.efs_enable_automatic_backups

  # Create mount targets inside the private subnets
  private_subnet_ids = module.vpc.private_subnet_ids

  # Protect the mount targets with the EFS security group
  efs_security_group_id = module.sg.efs_security_group_id
}
# ============================================================
# ECS IAM MODULE
# ============================================================

# Create the IAM roles used by ECS and the running Gatus task
module "ecs_iam" {
  source = "./modules/ecs-iam"

  # Role ECS uses to pull the image and send logs
  ecs_execution_role_name = var.ecs_execution_role_name

  # Role used by Gatus while the container is running
  ecs_task_role_name = var.ecs_task_role_name

  # Give the running task permission to use EFS
  efs_client_policy_name = var.efs_client_policy_name
  efs_file_system_arn    = module.efs.file_system_arn
}

# ============================================================
# EXISTING ECR REPOSITORY
# ============================================================

# Find the ECR repository created by the bootstrap configuration
data "aws_ecr_repository" "gatus" {
  name = var.ecr_repository_name
}

# ============================================================
# ECS MODULE
# ============================================================

# Create the ECS cluster, Task Definition and Service
module "ecs" {
  source = "./modules/ecs"

  # ECS cluster
  ecs_cluster_name = var.ecs_cluster_name

  # CloudWatch logging
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
  log_retention_days        = var.log_retention_days
  aws_region                = var.aws_region
  log_stream_prefix         = var.log_stream_prefix

  # Task Definition
  task_definition_family = var.task_definition_family
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory

  # Roles created by the ECS IAM module
  execution_role_arn = module.ecs_iam.ecs_execution_role_arn
  task_role_arn      = module.ecs_iam.ecs_task_role_arn

  # Match the ARM64 image
  operating_system_family = var.operating_system_family
  cpu_architecture        = var.cpu_architecture

  # Container configuration
  container_name = var.container_name

  # Build the complete ECR image address
  container_image = "${data.aws_ecr_repository.gatus.repository_url}:${var.container_image_tag}"

  application_port = var.application_port

  # Persistent EFS storage
  efs_volume_name    = var.efs_volume_name
  efs_file_system_id = module.efs.file_system_id
  efs_container_path = var.efs_container_path

  # ECS Service
  ecs_service_name         = var.ecs_service_name
  desired_task_count       = var.desired_task_count
  fargate_platform_version = var.fargate_platform_version
  capacity_provider        = var.capacity_provider
  capacity_provider_weight = var.capacity_provider_weight
  capacity_provider_base   = var.capacity_provider_base

  # Run the tasks inside the private subnets
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.sg.ecs_security_group_id

  # Register tasks with the ALB Target Group
  target_group_arn = module.alb.target_group_arn

  # Wait until the ALB and EFS mount targets are ready
  depends_on = [
    module.alb,
    module.efs
  ]
}
# ============================================================
# APPLICATION LOAD BALANCER MODULE
# ============================================================

# Create the public ALB, Target Group and listeners
module "alb" {
  source = "./modules/alb"

  # Place the ALB in the public side of the VPC
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = values(module.vpc.public_subnet_ids)

  # Protect the ALB with its Security Group
  alb_security_group_id = module.sg.alb_security_group_id

  # Application Load Balancer settings
  alb_name                   = var.alb_name
  alb_internal               = var.alb_internal
  load_balancer_type         = var.load_balancer_type
  enable_deletion_protection = var.enable_deletion_protection

  # Target Group settings
  target_group_name     = var.target_group_name
  application_port      = var.application_port
  target_group_protocol = var.target_group_protocol
  target_type           = var.target_type

  # Target health-check settings
  health_check_path     = var.health_check_path
  health_check_matcher  = var.health_check_matcher
  health_check_interval = var.health_check_interval
  health_check_timeout  = var.health_check_timeout
  healthy_threshold     = var.healthy_threshold
  unhealthy_threshold   = var.unhealthy_threshold

  # HTTP and HTTPS listener settings
  http_port       = var.http_port
  https_port      = var.https_port
  ssl_policy      = var.ssl_policy
  certificate_arn = module.acm.certificate_arn
}

# ============================================================
# ACM CERTIFICATE MODULE
# ============================================================

# Request and validate the HTTPS certificate for Gatus
module "acm" {
  source = "./modules/acm"

  # Certificate settings
  certificate_name  = var.certificate_name
  domain_name       = var.domain_name
  validation_method = var.validation_method
  key_algorithm     = var.key_algorithm

  # Put the ACM validation record inside the Route 53 zone
  hosted_zone_id        = module.route53.hosted_zone_id
  validation_record_ttl = var.validation_record_ttl
}