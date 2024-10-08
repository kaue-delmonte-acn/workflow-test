########################################################################################################################
## Create a public and private key pair for login to the EC2 Instances
########################################################################################################################

resource "aws_key_pair" "default" {
  key_name   = "${var.namespace}-key-pair-${var.environment}"
  public_key = var.public_ec2_key

  tags = {
    Environment = var.environment
  }
}
