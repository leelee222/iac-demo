output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_bucket.bucket_name
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "application_url" {
  description = "URL to access the deployed application"
  value       = "http://${module.ec2_instance.public_ip}"
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.sg_id
}

output "iam_role_name" {
  description = "Name of the IAM role attached to EC2"
  value       = module.iam.role_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value = module.iam.role_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

output "flow_logs_log_group" {
  description = "CloudWatch log group for VPC flow logs"
  value       = module.vpc.flow_logs_log_group
}
