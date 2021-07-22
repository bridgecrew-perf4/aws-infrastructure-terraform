##############################
#    Get AWS ami image id    #
##############################
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

##############################
#     Create AWS keypair     #
##############################
resource "aws_key_pair" "pem" {
  key_name   = "${var.var_name}-${var.var_dev_environment}-key"
  public_key = ""
}

##############################
#    Create EC2 instances    #
##############################
resource "aws_instance" "ec2" {
  count                       = 5
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
    private_key = file("./key/key.pem")
  }

  provisioner "local-exec" {
    command = "ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ec2-user -i '${self.public_ip},' --private-key ./key/key.pem ${var.ansible_playbook[count.index]}"
  }

}

##############################
#         Create EIP         #
##############################
resource "aws_eip" "eip" {
  count      = 5
  instance   = element(aws_instance.ec2.*.id, count.index)
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-${var.i_tags[count.index]}-eip"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}