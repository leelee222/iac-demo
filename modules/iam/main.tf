# ============================================
# IAM ROLE - Think of this as the "badge"
# ============================================

# This is the "badge" that EC2 will wear
resource "aws_iam_role" "ec2_role" {
  name = var.role_name

  # This is called "Trust Policy" - it defines WHO can wear this badge
  # In this case: Only EC2 instances can use this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"  # Only EC2 can assume this role
        }
      }
    ]
  })

  tags = {
    Name        = var.role_name
    Environment = var.environment
  }
}

# ============================================
# POLICY 1: CloudWatch Logs Permission
# ============================================

# This policy allows EC2 to send logs to CloudWatch
resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "${var.role_name}-cloudwatch-policy"
  role = aws_iam_role.ec2_role.id

  # What this policy allows:
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",      # Create a new log group
          "logs:CreateLogStream",     # Create a new log stream
          "logs:PutLogEvents",        # Send log messages
          "logs:DescribeLogStreams"   # Check existing logs
        ]
        Resource = "arn:aws:logs:*:*:*"  # Apply to all logs
      }
    ]
  })
}

# ============================================
# POLICY 2: S3 Read-Only Permission
# ============================================

# This policy allows EC2 to READ from S3 (but NOT write/delete)
resource "aws_iam_role_policy" "s3_read_policy" {
  name = "${var.role_name}-s3-read-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",           # Download files
          "s3:ListBucket",          # List files in bucket
          "s3:GetBucketLocation"    # Check bucket region
          # NOTE: NO PutObject, DeleteObject, etc. (read-only!)
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",      # The bucket itself
          "arn:aws:s3:::${var.bucket_name}/*"     # All files in bucket
        ]
      }
    ]
  })
}

# ============================================
# INSTANCE PROFILE - The "badge holder"
# ============================================

# This is how we attach the IAM role to EC2
# Think of it as the "badge holder" that clips onto EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "${var.role_name}-profile"
    Environment = var.environment
  }
}