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

# ------------------------
# S3 Bucket (Storage)
# ------------------------
resource "aws_s3_bucket" "iac_demo_bucket" {
  bucket = "iac-demo-bucket-local-${random_id.bucket_id.hex}"

  tags = {
    Name        = "iac-demo-bucket"
    Environment = "local"
  }
}

# Random suffix so bucket names are unique
resource "random_id" "bucket_id" {
  byte_length = 4
}

# ------------------------
# Fake EC2 Instance (for testing)
# ------------------------
resource "aws_instance" "iac_demo_instance" {
  ami           = "ami-12345678"   # Dummy ID for LocalStack
  instance_type = "t2.micro"
  tags = {
    Name = "iac-demo-instance"
  }
}
