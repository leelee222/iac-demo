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

module "security_group" {
  source  = "./modules/security_group"
  sg_name = "iac-demo-sg"
}

module "ec2_instance" {
  source         = "./modules/ec2"
  instance_name  = "iac-demo-instance"
  instance_type  = var.instance_type
  sg_id          = module.security_group.sg_id
}

module "s3_bucket" {
  source        = "./modules/s3_bucket"
  bucket_prefix = var.bucket_prefix
  environment   = "local"
}
