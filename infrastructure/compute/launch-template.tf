########################################################################################################################
## Get most recent AMI for an ECS-optimized Amazon Linux 2 instance
########################################################################################################################

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

########################################################################################################################
## Launch template for all EC2 instances that are part of the ECS cluster
########################################################################################################################

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${var.namespace}-ec2-launch-template-${var.environment}"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.default.key_name
  user_data              = base64encode(data.template_file.default.rendered)
  vpc_security_group_ids = [var.ec2_security_group]

  iam_instance_profile {
    arn = var.ec2_profile
  }

  monitoring {
    enabled = true
  }

  tags = {
    Environment = var.environment
  }
}

data "template_file" "default" {
  template = file("${path.module}/user-data.sh")

  vars = {
    ecs_cluster_name = var.ecs_cluster
  }
}
