resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_prefix}-local-${random_id.bucket_id.hex}"

  tags = {
    Name        = "${var.bucket_prefix}-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
