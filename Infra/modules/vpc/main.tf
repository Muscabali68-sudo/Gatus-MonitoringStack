# Create the Gatus VPC
resource "aws_vpc" "gatus_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}


# Create one subnet for every item passed into var.subnets
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  # Place every subnet inside the Gatus VPC
  vpc_id = aws_vpc.gatus_vpc.id

  # Read the configuration for the current subnet
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  # Public subnets get public IPs; private subnets do not
  map_public_ip_on_launch = each.value.public_ip

  # each.key contains public-1a, private-1a and so on
  tags = {
    Name = "gatus-${each.key}-subnet"
  }
} 

# Create the Internet Gateway
resource "aws_internet_gateway" "gatus_igw" {
  # Internet Gateway: "Attach me to the Gatus VPC."
  vpc_id = aws_vpc.gatus_vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# Give private resources outbound access to the internet
resource "aws_nat_gateway" "gatus_nat_gateway" {
  vpc_id = aws_vpc.gatus_vpc.id

  availability_mode = var.availability_mode
  connectivity_type = var.connectivity_type

  tags = {
    Name = var.nat_gateway_name
  }
}