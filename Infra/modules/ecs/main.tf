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