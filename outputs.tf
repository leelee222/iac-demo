output "bucket_name" {
  value = aws_s3_bucket.iac_demo_bucket.bucket
}

output "instance_id" {
  value = aws_instance.iac_demo_instance.id
}
