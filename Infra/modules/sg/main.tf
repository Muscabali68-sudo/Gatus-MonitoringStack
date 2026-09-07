# ============================================================
# ALB SECURITY GROUP
# ============================================================

# Create the security group used by the Application Load Balancer
resource "aws_security_group" "alb" {
  name        = var.alb_security_group_name
  description = var.alb_security_group_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.alb_security_group_name
  }
}


# ============================================================
# ALB INBOUND RULES
# ============================================================

# Allow HTTP traffic for the future HTTPS redirect
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = var.alb_ingress_cidr
  from_port   = var.http_port
  to_port     = var.http_port
  ip_protocol = var.tcp_protocol
}


# Allow secure HTTPS traffic from the internet
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = var.alb_ingress_cidr
  from_port   = var.https_port
  to_port     = var.https_port
  ip_protocol = var.tcp_protocol
}

# ============================================================
# ALB OUTBOUND RULE
# ============================================================

# Allow the ALB to pass requests to the Gatus ECS tasks
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  # Add this outbound rule to the ALB security group
  security_group_id = aws_security_group.alb.id

  # Only allow traffic going to the ECS task security group
  referenced_security_group_id = aws_security_group.ecs_task.id

  # Gatus listens on TCP port 8080
  from_port   = var.application_port
  to_port     = var.application_port
  ip_protocol = var.tcp_protocol
} 

# ============================================================
# ECS TASK SECURITY GROUP
# ============================================================

# Protect the Gatus application running inside ECS Fargate
resource "aws_security_group" "ecs_task" {
  name        = var.ecs_security_group_name
  description = var.ecs_security_group_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.ecs_security_group_name
  }
}
# ============================================================
# ECS INBOUND RULE
# ============================================================

# Only allow the ALB to reach Gatus on port 8080
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  # Add this rule to the ECS security group
  security_group_id = aws_security_group.ecs_task.id

  # Only accept traffic coming from the ALB security group
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = var.application_port
  to_port     = var.application_port
  ip_protocol = var.tcp_protocol
} 

# ============================================================
# ECS OUTBOUND RULE TO EFS
# ============================================================

# Allow the ECS tasks to connect to EFS on port 2049
resource "aws_vpc_security_group_egress_rule" "ecs_to_efs" {
  security_group_id = aws_security_group.ecs_task.id

  # Only allow storage traffic going to the EFS security group
  referenced_security_group_id = aws_security_group.efs.id

  from_port   = var.efs_port
  to_port     = var.efs_port
  ip_protocol = var.tcp_protocol
}

# ============================================================
# EFS SECURITY GROUP
# ============================================================

# Create the security group used by the EFS mount targets
resource "aws_security_group" "efs" {
  name        = var.efs_security_group_name
  description = var.efs_security_group_description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.efs_security_group_name
  }
}


# ============================================================
# EFS INBOUND RULE
# ============================================================

# Allow EFS connections only from the ECS tasks
resource "aws_vpc_security_group_ingress_rule" "efs_from_ecs" {
  # Add this inbound rule to the EFS security group
  security_group_id = aws_security_group.efs.id

  # Only accept connections from the ECS security group
  referenced_security_group_id = aws_security_group.ecs_task.id

  # EFS uses NFS over TCP port 2049
  from_port   = var.efs_port
  to_port     = var.efs_port
  ip_protocol = var.tcp_protocol
}
