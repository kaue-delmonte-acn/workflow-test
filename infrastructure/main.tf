module "roles" {
  source      = "./roles"
  namespace   = var.namespace
  environment = var.environment
}

module "logs" {
  source      = "./logs"
  namespace   = var.namespace
  environment = var.environment
}

module "network" {
  source      = "./network"
  namespace   = var.namespace
  environment = var.environment
}

module "compute" {
  source                 = "./compute"
  namespace              = var.namespace
  environment            = var.environment
  public_ec2_key         = var.public_ec2_key
  ec2_profile            = module.roles.ec2_profile
  vpc_id                 = module.network.vpc_id
  public_subnets         = module.network.public_subnets
  private_subnets        = module.network.private_subnets
  ec2_security_group     = module.network.ec2_security_group
  alb_security_group     = module.network.alb_security_group
  bastion_security_group = module.network.bastion_security_group
  ecs_cluster            = module.cluster.ecs_cluster
}

module "cluster" {
  source                  = "./cluster"
  namespace               = var.namespace
  environment             = var.environment
  aws_region              = var.aws_region
  ecs_service_role        = module.roles.ecs_service_role
  ecs_task_role           = module.roles.ecs_task_role
  ecs_task_execution_role = module.roles.ecs_task_execution_role
  log_group               = module.logs.log_group
  alb_target_group        = module.compute.alb_target_group
  autoscaling_group       = module.compute.autoscaling_group
}

module "database" {
  source             = "./database"
  namespace          = var.namespace
  environment        = var.environment
  rds_username       = var.rds_username
  rds_password       = var.rds_password
  rds_db_name        = var.rds_db_name
  rds_db_username    = var.rds_db_username
  rds_db_password    = var.rds_db_password
  database_subnets   = module.network.database_subnets
  rds_security_group = module.network.rds_security_group
}

output "alb_dns" {
  value = module.compute.alb_dns
}
