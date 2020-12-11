provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

#######
# VPC #
#######
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-vpc"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

############
# Subnet 1 #
############
# resource "aws_subnet" "subnet_1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "200.1.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = data.aws_availability_zones.available_az.names[0]
#   tags = {
#     Name               = "${var.var_name}-${var.var_dev_environment}-public-subnet-1"
#     "user:Client"      = var.var_name
#     "user:Environment" = var.var_dev_environment
#   }
# }

# ############
# # Subnet 2 #
# ############
# resource "aws_subnet" "subnet_2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "200.1.2.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = data.aws_availability_zones.available_az.names[1]
#   tags = {
#     Name               = "${var.var_name}-${var.var_dev_environment}-public-subnet-2"
#     "user:Client"      = var.var_name
#     "user:Environment" = var.var_dev_environment
#   }
# }

####################
# Internet Gateway #
####################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-igw"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}
############
# Subnet 2 #
############
resource "aws_subnet" "public_subnets" {
  for_each                = { for index, az_name in local.az_names : index => az_name }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = local.az_names[each.key]
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-public-subnet-2"
    Test               = each.key
    valuetest          = each.value
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

#################
# Routing Table #
#################
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-rt"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}
###########################
# Route table association #
###########################
resource "aws_route_table_association" "assoc_route_table_subnets" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}
# resource "aws_route_table_association" "assoc_route_table_subnet_1" {
#   subnet_id      = aws_subnet.subnet_1.id
#   route_table_id = aws_route_table.route_table.id
# }
# resource "aws_route_table_association" "assoc_route_table_subnet_2" {
#   subnet_id      = aws_subnet.subnet_2.id
#   route_table_id = aws_route_table.route_table.id
# }
