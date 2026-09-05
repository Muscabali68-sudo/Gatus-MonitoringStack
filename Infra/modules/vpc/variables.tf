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