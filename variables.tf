variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "iac-demo"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to access SSH (port 22). Use your IP address for security."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
