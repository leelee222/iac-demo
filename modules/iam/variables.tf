variable "role_name" {
  description = "Name of the IAM role for EC2"
  type        = string
  default     = "ec2-cloudwatch-s3-role"
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "local"
}

variable "bucket_name" {
  description = "S3 bucket name that EC2 should have read access to"
  type        = string
}