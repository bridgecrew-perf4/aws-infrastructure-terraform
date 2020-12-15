#############
# Obtain AZ #
#############
# data "aws_availability_zones" "available_az" {
#   state = "available"
# }

#########################
# Get AWS ami image id #
#########################
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
