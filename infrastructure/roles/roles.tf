########################################################################################################################
## Creates IAM Role which is assumed by the Container Instances (aka EC2 Instances)
########################################################################################################################

data "aws_iam_policy_document" "ec2_instance" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ec2_instance" {
  name               = "${var.namespace}-ec2-instance-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ec2_instance" {
  role       = aws_iam_role.ec2_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance" {
  name = "${var.namespace}-ec2-instance-role-profile-${var.environment}"
  role = aws_iam_role.ec2_instance.id

  tags = {
    Environment = var.environment
  }
}

########################################################################################################################
## Create service-linked role used by the ECS Service to manage the ECS Cluster
########################################################################################################################

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", ]
    }
  }
}

resource "aws_iam_role" "ecs_service" {
  name               = "${var.namespace}-ecs-service-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_policy.json

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "ecs_service_role_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:DescribeTags",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutSubscriptionFilter",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_service" {
  name   = "${var.namespace}-ecs-service-role-policy-${var.environment}"
  policy = data.aws_iam_policy_document.ecs_service_role_policy.json
  role   = aws_iam_role.ecs_service.id
}

########################################################################################################################
## IAM Role for ECS Task execution
########################################################################################################################

data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.namespace}-ecs-task-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

########################################################################################################################
## IAM Role for ECS Task
########################################################################################################################

resource "aws_iam_role" "ecs_task" {
  name               = "${var.namespace}-ecs-task-iam-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json

  tags = {
    Environment = var.environment
  }
}
