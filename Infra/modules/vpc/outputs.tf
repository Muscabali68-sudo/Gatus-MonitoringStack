# Allow other modules to use the VPC ID
output "vpc_id" {
  description = "ID of the Gatus VPC"
  value       = aws_vpc.gatus_vpc.id
}


# Allow other modules to use the public subnet IDs
output "public_subnet_ids" {
  description = "IDs of the public subnets"

  value = {
    for key, subnet in aws_subnet.subnets :
    key => subnet.id
    if var.subnets[key].public_ip
  }
}


# Allow other modules to use the private subnet IDs
output "private_subnet_ids" {
  description = "IDs of the private subnets"

  value = {
    for key, subnet in aws_subnet.subnets :
    key => subnet.id
    if !var.subnets[key].public_ip
  }
} 