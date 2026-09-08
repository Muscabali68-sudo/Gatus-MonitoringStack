# ============================================================
# APPLICATION LOAD BALANCER
# ============================================================

# Create the public entry point for the Gatus application
resource "aws_lb" "gatus_alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.load_balancer_type

  # Place the ALB in both public subnets
  subnets = var.public_subnet_ids

  # Protect the ALB with its security group
  security_groups = [var.alb_security_group_id]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.alb_name
  }
}


# ============================================================
# GATUS TARGET GROUP
# ============================================================

# Create the destination group for the Gatus Fargate tasks
resource "aws_lb_target_group" "gatus_target_group" {
  name        = var.target_group_name
  port        = var.application_port
  protocol    = var.target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  # Check whether the Gatus tasks are healthy
  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = var.target_group_protocol
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name = var.target_group_name
  }
}


# ============================================================
# HTTPS LISTENER
# ============================================================

# Receive secure traffic and forward it to Gatus
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.gatus_alb.arn

  port            = var.https_port
  protocol        = "HTTPS"
  ssl_policy      = var.ssl_policy
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gatus_target_group.arn
  }
}


# ============================================================
# HTTP REDIRECT LISTENER
# ============================================================

# Redirect insecure HTTP requests to HTTPS
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.gatus_alb.arn

  port     = var.http_port
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = tostring(var.https_port)
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
