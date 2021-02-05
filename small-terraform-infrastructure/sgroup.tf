#########################
#    Security Groups    #
#########################
resource "aws_security_group" "main_sg" {
  name        = "${var.var_name}-main-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "SSH and Web ports for EC2 single server"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  
  ingress {
    cidr_blocks = ["200.1.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  dynamic "ingress" {
    for_each = local.ingress_rules_main
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "TCP"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = {
    Name               = "${var.var_name}-main-sg"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.var_name}-db-sg"
  description = "DB ports for EC2 single server"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = local.ingress_rules_db
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "TCP"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = {
    Name               = "${var.var_name}-db-sg"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}
