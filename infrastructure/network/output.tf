########################################################################################################################
## Network output
########################################################################################################################

output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.default.id
}

output "public_subnets" {
  description = "List of Public Subnets ids"
  value       = aws_subnet.public.*.id
}

output "private_subnets" {
  description = "List of Public Subnets ids"
  value       = aws_subnet.private.*.id
}

output "database_subnets" {
  description = "List of Database Subnets ids"
  value       = aws_subnet.database.*.id
}

output "ec2_security_group" {
  description = "EC2 Instance Security Group"
  value       = aws_security_group.ec2.id
}

output "alb_security_group" {
  description = "Load Balancer Security Group"
  value       = aws_security_group.alb.id
}

output "rds_security_group" {
  description = "Database Security Group"
  value       = aws_security_group.rds.id
}

output "bastion_security_group" {
  description = "Bastion Instance Security Group"
  value       = aws_security_group.bastion.id
}
