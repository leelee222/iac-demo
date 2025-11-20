
provider "aws" {
  region = var.aws_region
  

  
  default_tags {
    tags = {
      Project     = "iac-demo"
      ManagedBy   = "Terraform"
      Environment = "learning"
    }
  }
}

