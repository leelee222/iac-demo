output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_bucket.bucket_name
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
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
  value       = module.iam.role_arn
}
