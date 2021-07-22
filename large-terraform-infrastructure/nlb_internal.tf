################################
# Define Network Load Balancer #
################################
resource "aws_lb" "nlb_internal_grpc" {
  name = "${var.var_name}-${var.var_dev_environment}-internal-grpc-nlb"

  load_balancer_type               = "network"
  internal                         = true
  subnets                          = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]
  enable_cross_zone_load_balancing = true

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-internal-grpc-nlb"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

################################
# Define Service Target Groups #
################################
resource "aws_lb_target_group" "tg-os-grpc" {
  name     = "${var.var_name}-os-grpc-target"
  port     = 8081
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "TCP"
  }

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-os-grpc-target"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

resource "aws_lb_target_group" "tg-ums-grpc" {
  name     = "${var.var_name}-ums-grpc-target"
  port     = 8096
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "TCP"
  }

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-ums-grpc-target"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

###################################################
# Attach Octopus OS EC2 instance to target group  #
###################################################
resource "aws_lb_target_group_attachment" "os-1-tg-assoc" {
  target_group_arn = aws_lb_target_group.tg-os-grpc.arn
  target_id        = aws_instance.ec2[0].id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "os-2-tg-assoc" {
  target_group_arn = aws_lb_target_group.tg-os-grpc.arn
  target_id        = aws_instance.ec2[1].id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "ums-1-tg-assoc" {
  target_group_arn = aws_lb_target_group.tg-ums-grpc.arn
  target_id        = aws_instance.ec2[0].id
  port             = 8096
}

resource "aws_lb_target_group_attachment" "ums-2-tg-assoc" {
  target_group_arn = aws_lb_target_group.tg-ums-grpc.arn
  target_id        = aws_instance.ec2[1].id
  port             = 8096
}

##########################################
# Define Network Load Balancer Listeners #
##########################################
resource "aws_lb_listener" "nlb_listener_os" {
  load_balancer_arn = aws_lb.nlb_internal_grpc.arn
  protocol          = "TCP"
  port              = "8081"

  default_action {
    target_group_arn = aws_lb_target_group.tg-os-grpc.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "nlb_listener_ums" {
  load_balancer_arn = aws_lb.nlb_internal_grpc.arn
  protocol          = "TCP"
  port              = "8096"

  default_action {
    target_group_arn = aws_lb_target_group.tg-ums-grpc.arn
    type             = "forward"
  }
}
