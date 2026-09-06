# CIDR block used by the VPC
variable "vpc_cidr_block" {
  description = "CIDR block used by the VPC"
  type        = string
}


# Controls whether AWS DNS resolution is enabled
variable "enable_dns_support" {
  description = "Enable DNS support inside the VPC"
  type        = bool
}


# Controls whether resources can receive DNS hostnames
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames inside the VPC"
  type        = bool
}


# Name tag applied to the VPC
variable "vpc_name" {
  description = "Name tag applied to the VPC"
  type        = string
}


# Configuration for all public and private subnets
variable "subnets" {
  description = "Public and private subnets created inside the VPC"

  type = map(object({
    cidr_block        = string
    availability_zone = string
    public_ip         = bool
  }))
}

# Name tag applied to the Internet Gateway
variable "internet_gateway_name" {
  description = "Name tag applied to the Internet Gateway"
  type        = string
}

# Name applied to the NAT Gateway
variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
}

# Controls whether the NAT Gateway is regional or zonal
variable "availability_mode" {
  description = "Availability mode of the NAT Gateway"
  type        = string
}

# Controls whether the NAT Gateway uses public or private connectivity
variable "connectivity_type" {
  description = "Connectivity type of the NAT Gateway"
  type        = string
} 

# Name applied to the public route table
variable "public_route_table_name" {
  description = "Name of the public route table"
  type        = string
}

# Name applied to the private route table
variable "private_route_table_name" {
  description = "Name of the private route table"
  type        = string
}

# Destination representing all IPv4 addresses
variable "route_destination_cidr_block" {
  description = "Destination CIDR block used by the internet routes"
  type        = string
}