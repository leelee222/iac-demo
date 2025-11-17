variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "iac-demo-instance"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
  default     = null
}

variable "sg_id" {
  description = "Security group ID to attach to the instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to EC2"
  type        = string
  default     = ""
}

