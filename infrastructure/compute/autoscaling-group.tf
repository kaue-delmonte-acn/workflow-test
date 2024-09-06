########################################################################################################################
## Creates an ASG linked with our main VPC
########################################################################################################################

resource "aws_autoscaling_group" "default" {
  name                  = "${var.namespace}-asg-${var.environment}"
  max_size              = 4
  min_size              = 2
  vpc_zone_identifier   = var.private_subnets
  health_check_type     = "EC2"
  protect_from_scale_in = true

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.namespace}-asg-${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = false
    value               = var.environment
  }
}
