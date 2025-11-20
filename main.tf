terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "us-east-1a"
  environment         = "local"
  allowed_ssh_cidr    = var.allowed_ssh_cidr[0]
}

module "security_group" {
  source           = "./modules/security_group"
  sg_name          = "iac-demo-sg"
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "s3_bucket" {
  source        = "./modules/s3_bucket"
  bucket_prefix = var.bucket_prefix
  environment   = "local"
}

module "iam" {
  source      = "./modules/iam"
  role_name   = "iac-demo-ec2-role"
  environment = "local"
  bucket_name = module.s3_bucket.bucket_name
}

module "ec2_instance" {
  source               = "./modules/ec2"
  instance_name        = "iac-demo-instance"
  instance_type        = var.instance_type
  subnet_id            = module.vpc.public_subnet_id
  sg_id                = module.security_group.sg_id
  iam_instance_profile = module.iam.instance_profile_name
}
