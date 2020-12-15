###################
# Security Groups #
###################
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

  dynamic "ingress" {
    for_each = local.ingress_rules_main
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "TCP"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # ingress {
  #   cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30", "15.188.31.234/32"]
  #   protocol    = "TCP"
  #   from_port   = 22
  #   to_port     = 22
  # }
  # ingress {
  #   cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30", "34.254.36.247/32", "50.16.146.15/32"]
  #   protocol    = "TCP"
  #   from_port   = 10050
  #   to_port     = 10050
  # }
  # ingress {
  #   cidr_blocks = ["200.1.0.0/16"]
  #   protocol    = "-1"
  #   from_port   = 0
  #   to_port     = 0
  # }
  # ingress {
  #   cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30"]
  #   protocol    = "TCP"
  #   from_port   = 15672
  #   to_port     = 15672
  # }

  tags = {
    Name               = "${var.var_name}-main-sg"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

# resource "aws_security_group" "web_sg" {
#   vpc_id      = aws_vpc.vpc.id
#   name        = "${var.var_name}-web-sg"
#   description = "Web ports for EC2 single server"
#   egress {
#     cidr_blocks = ["0.0.0.0/0"]
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#   }

#   dynamic "ingress" {
#     for_each = local.ingress_rules_web
#   }
#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     protocol    = "TCP"
#     from_port   = 80
#     to_port     = 80
#   }
#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     protocol    = "TCP"
#     from_port   = 443
#     to_port     = 443
#   }
#   tags = {
#     Name               = "${var.var_name}-web-sg"
#     "user:Client"      = var.var_name
#     "user:Environment" = var.var_dev_environment
#   }
# }

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

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["200.1.0.0/16", "217.24.19.64/29", "82.117.216.88/30"]
  }

  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "TCP"
    cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30", "34.254.36.247/32", "50.16.146.15/32"]
  }

  tags = {
    Name               = "${var.var_name}-db-sg"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}
