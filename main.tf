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
  source           = "./modules/security_group"
  sg_name          = "iac-demo-sg"
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "s3_bucket" {
  source        = "./modules/s3_bucket"
  bucket_prefix = var.bucket_prefix
  environment   = "local"
}

# ✨ NEW: Create IAM role with CloudWatch and S3 permissions
module "iam" {
  source      = "./modules/iam"
  role_name   = "iac-demo-ec2-role"
  environment = "local"
  bucket_name = module.s3_bucket.bucket_name  # Grant access to our S3 bucket
}

module "ec2_instance" {
  source               = "./modules/ec2"
  instance_name        = "iac-demo-instance"
  instance_type        = var.instance_type
  sg_id                = module.security_group.sg_id
  iam_instance_profile = module.iam.instance_profile_name  # ✨ Attach IAM role
}
