

##############################
#     Create AWS keypair     #
##############################
resource "aws_key_pair" "pem" {
  key_name   = "carnegie1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5IkRNJQtrROT8pjKJeoA8lF7wQ6wfIcj4xxE/nRc19xTebwOMlYfpfTRfSk65FjFkf0xLuDTpa8r/dA+tmkMkj3oCFR+UKCyTFyhxWbRvVzaRckk+ph8BcENNMHd8uAAukBnHlJiPwI1+BCaSNR1LhUGTRBiiTJMK8dxfBHnfGfSm3s7j8yVQbYcGk8GC8cYk5m6ZfF3UBeD0/P6mdx0eIKCGkfk2yWFHOK+BAJgwC0GNPChxHY07ywBk7+X7fIj3+ldyXIH+vtBkx6nWXJ1nw9zz1mFCa9QziybsglcOS//zKxmQ4lAVOcul4xpiY6fODHtXKS2RB1dm0ADKuDUb CarnegieKey"
}

###############################
#     Create EC2 instance     #
###############################
resource "aws_instance" "ec2" {
  count                       = length(aws_subnet.public_subnets)
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = local.i_type[count.index]
  key_name                    = aws_key_pair.pem.key_name
  security_groups             = [aws_security_group.main_sg.id]
  subnet_id                   = element(aws_subnet.public_subnets.*.id, 0)
  associate_public_ip_address = "true"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = "true"
  }

  volume_tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-${var.i_tags[count.index]}-volume"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-${var.i_tags[count.index]}"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }

  provisioner "remote-exec" {
    inline = ["sleep 80"]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("./key/carnegie1.pem")
  }

  provisioner "local-exec" {
    command = "ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ec2-user -i '${self.public_ip},' --private-key ./key/carnegie1.pem ${var.ansible_playbook[count.index]}"
  }

}

###############################
#         Create EIPs         #
###############################
resource "aws_eip" "eip" {
  count      = length(aws_subnet.public_subnets)
  instance   = element(aws_instance.ec2.*.id, count.index)
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-${var.i_tags[count.index]}-eip"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}


# resource "aws_instance" "transcoder" {
#   #count = length(aws_subnet.public_subnets)
#   ami   = data.aws_ami.amazon_linux.id
#   #instance_type               = local.condition_type == "${var.var_name}-${var.var_dev_environment}-all" ? var.i_type_all : var.i_type_transcoder
#   instance_type               = var.i_type_transcoder
#   key_name                    = aws_key_pair.pem.key_name
#   security_groups             = [aws_security_group.main_sg.id]
#   subnet_id                   = element(aws_subnet.public_subnets.*.id, 0)
#   associate_public_ip_address = "true"

# #   dynamic "key_name" {
# #     for_each = local.instance_types

# #     content {
# #       instance_type = instance_typ.value.type
# #     }
# #   }

#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = 20
#     delete_on_termination = "true"
#   }

#   volume_tags = {
#     Name               = "${var.var_name}-${var.var_dev_environment}-transcoder-volume"
#     "user:Client"      = var.var_name
#     "user:Environment" = var.var_dev_environment
#   }

#   tags = {
#     Name               = "${var.var_name}-${var.var_dev_environment}-transcoder"
#     "user:Client"      = var.var_name
#     "user:Environment" = var.var_dev_environment
#   }
# }
