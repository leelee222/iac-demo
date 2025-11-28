#!/bin/bash

set -e

BUCKET_NAME="iac-demo-terraform-state-leelee222"
TABLE_NAME="terraform-state-lock"
REGION="us-east-1"

echo "1. Creating S3 bucket for Terraform state..."
if [ "$REGION" = "us-east-1" ]; then
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" 2>/dev/null || echo "Bucket already exists"
else
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION" 2>/dev/null || echo "Bucket already exists"
fi

echo "2. Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --versioning-configuration Status=Enabled

echo "3. Enabling encryption on S3 bucket..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "4. Blocking public access on S3 bucket..."
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "5. Creating DynamoDB table for state locking..."
aws dynamodb create-table \
  --table-name "$TABLE_NAME" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$REGION" 2>/dev/null || echo "Table already exists"