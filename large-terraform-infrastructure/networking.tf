#######################
#       Provider       #
#######################
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

########################
#         VPC          #
########################
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

#########################
#    Internet Gateway   #
#########################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-igw"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}
##########################
#         Subnet         #
##########################
resource "aws_subnet" "public_subnets" {
  count                   = local.public_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.newbits, count.index + 1)
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-public-subnet-${count.index + 1}"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

###########################
#      Routing Table      #
###########################
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
