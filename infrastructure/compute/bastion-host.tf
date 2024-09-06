########################################################################################################################
## Bastion host EC2 Instance
########################################################################################################################

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.default.id
  vpc_security_group_ids      = [var.bastion_security_group]

  tags = {
    Name        = "${var.namespace}-ec2-bastion-host-${var.environment}"
    Environment = var.environment
  }
}
