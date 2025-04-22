module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source                = "./modules/subnets"
  vpc_id                = module.vpc.vpc_id
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                   = ["eu-central-1a", "eu-central-1b"]
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source             = "./modules/nat-gateway"
  az_count           = 2
  public_subnet_ids  = module.subnets.public_subnet_ids
}

module "route-tables" {
  source = "./modules/route-tables"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.igw.igw_id
  nat_gateway_ids    = module.nat.nat_gateway_ids
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  az_count           = 2
}


module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "nacl" {
  source             = "./modules/nacl"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.subnets.private_subnet_ids
  vpc_cidr           = module.vpc.cidr_block
}


module "iam" {
  source = "./modules/iam"
}


module "launch_template" {
  source               = "./modules/launch_template"
  ami_id               = data.aws_ami.amazon_linux.id
  instance_type        = "t3.micro"
  iam_instance_profile = module.iam.instance_profile_name
  sg_id                = module.security_groups.ec2_sg_id
  user_data            = file("${path.module}/user_data.sh")
}


module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids
  sg_id      = module.security_groups.alb_sg_id
  alb_name = "wordpress-alb" 
  log_bucket = module.monitoring.log_bucket_name
}


module "asg" {
  source               = "./modules/asg"
  subnet_ids           = module.subnets.public_subnet_ids
  launch_template_id   = module.launch_template.id
  launch_template_version = "$Latest"
  target_group_arn     = module.alb.target_group_arn
  desired_capacity     = 2
  min_size             = 1
  max_size             = 4
}


module "rds" {
  source               = "./modules/rds"
  db_name              = "wordpress"
  db_username          = "wpadmin"
  db_password          = random_password.db_password.result
  db_instance_class    = "db.t3.micro"
  subnet_ids           = module.subnets.private_subnet_ids
  vpc_id               = module.vpc.vpc_id
  rds_sg_id            = module.security_groups.rds_sg_id
  multi_az             = true
  monitoring_role_arn  = module.iam.rds_monitoring_role
}

resource "random_password" "db_password" {
  length  = 20
  special = false
}

module "monitoring" {
  source              = "./modules/monitoring"
  asg_name            = module.asg.asg_name
  alb_name            = module.alb.alb_name
  rds_identifier      = module.rds.db_instance_id
  log_bucket_name     = "my-alb-logs-bucket-5m5d"
  notification_topic  = module.sns.sns_topic_arn
  scale_out_policy_arn = module.asg.scale_out_policy_arn   
  scale_in_policy_arn  = module.asg.scale_in_policy_arn
}


module "sns" {
  source = "./modules/sns"
}
