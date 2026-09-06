# Send the VPC ID back to the root module
output "vpc_id" {
  description = "ID of the Gatus VPC"
  value       = aws_vpc.gatus_vpc.id
}


# Send all public subnet IDs back to the root module
output "public_subnet_ids" {
  description = "IDs of the public subnets"

  # Keep only subnets where public_ip is true
  value = {
    for key, subnet in aws_subnet.subnets :
    key => subnet.id
    if var.subnets[key].public_ip
  }
}


# Send all private subnet IDs back to the root module
output "private_subnet_ids" {
  description = "IDs of the private subnets"

  # Keep only subnets where public_ip is false
  value = {
    for key, subnet in aws_subnet.subnets :
    key => subnet.id
    if !var.subnets[key].public_ip
  }
}