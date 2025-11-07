resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_prefix}-local-${random_id.bucket_id.hex}"

  tags = {
    Name        = "${var.bucket_prefix}-bucket"
    Environment = var.environment
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
