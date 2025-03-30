provider "aws" {
  region = var.aws_region
}

resource "null_resource" "workspace_check" {
  provisioner "local-exec" {
    command = "echo Using workspace: ${terraform.workspace}"
  }
}

module "vpc" {
  source = "./modules/vpc"
  environment = terraform.workspace
}

module "s3" {
  source = "./modules/s3"
  environment = terraform.workspace
  bucket_name = "${terraform.workspace}-bucket-${module.s3.random_suffix}" # Compute here
}

module "iam" {
  source = "./modules/iam"
  environment = terraform.workspace
}

module "load_balancer" {
  source = "./modules/load_balancer"
  environment = terraform.workspace
  vpc_id = module.vpc.vpc_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
}

module "auto_scaling" {
  source = "./modules/auto_scaling"
  environment = terraform.workspace
  vpc_id = module.vpc.vpc_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  target_group_arn = module.load_balancer.target_group_arn
  iam_instance_profile = module.iam.instance_profile_name
}

module "hoor" {
  source = "./modules/hoor"
  environment = terraform.workspace
  s3_bucket_domain_name = module.s3.bucket_domain_name
  load_balancer_dns = module.load_balancer.lb_dns_name
}