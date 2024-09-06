########################################################################################################################
## Application Load Balancer in public subnets with HTTP default listener that redirects traffic to HTTPS
########################################################################################################################

resource "aws_alb" "default" {
  name            = "${var.namespace}-alb-${var.environment}"
  security_groups = [var.alb_security_group]
  subnets         = var.public_subnets

  tags = {
    Environment = var.environment
  }
}

########################################################################################################################
## *TEST* Listener that allows traffic on default HTTP port
########################################################################################################################

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.default.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default.arn
  }

  tags = {
    Environment = var.environment
  }

}

########################################################################################################################
## Default HTTPS listener
########################################################################################################################

# resource "aws_alb_listener" "alb_default_listener_https" {
#   load_balancer_arn = aws_alb.alb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   certificate_arn   = aws_acm_certificate.alb_certificate.arn
#   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

# default_action {
#   type             = "forward"
#   target_group_arn = aws_alb_target_group.service_target_group.arn
# }

#   tags = {
#     Environment = var.environment
#   }

#   depends_on = [aws_acm_certificate.alb_certificate]
# }

########################################################################################################################
## Target Group for our service
########################################################################################################################

resource "aws_alb_target_group" "default" {
  name                 = "${var.namespace}-target-group-${var.environment}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 5

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_alb.default]
}
