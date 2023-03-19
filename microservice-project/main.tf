provider "aws" {
  region  = var.region
  profile = "terraform-user"
}

#Create VPC module
module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

#Create NAT Gateway module
module "nat-gateway" {
  source                     = "../modules/nat-gateway"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  internet_gateway           = module.vpc.internet_gateway
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

#Create Security Group module
module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

#Create ECS Task Execution Role module
module "ecs-tasks-exec-role" {
  source       = "../modules/ecs-tasks-exec-role"
  project_name = var.project_name
}

#Create SSL Certificate module
/* module "acm" {
  source           = "../modules/acm"
  domain_name      = var.domain_name
  alternative_name = var.alternative_name
} */

#Create ALB module
/* module "alb" {
  source                     = "../modules/alb"
  project_name               = module.vpc.project_name
  vpc_id                     = module.vpc.vpc_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  alb_security_group_id      = module.security-group.alb_security_group_id
  certificate_arn            = module.acm.certificate_arn
} */

#Create ec2 module
module "ec2" {
  source                     = "../modules/ec2"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  jenkins_security_group_id  = module.security-group.jenkins_security_group_id
  k8s_security_group_id      = module.security-group.k8s_security_group_id

}
