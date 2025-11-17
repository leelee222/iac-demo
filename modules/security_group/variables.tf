variable "sg_name" {
  description = "Security group name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach the security group to"
  type        = string
  default     = null
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to access SSH (port 22)"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
