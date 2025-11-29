# Cloud Deployment Guide

A simple, step-by-step guide to deploying infrastructure and applications to AWS using this project.

---

## Overview

This project uses Terraform to provision AWS infrastructure and GitHub Actions to automate security scanning and deployment. Everything runs through a CI/CD pipeline that ensures your infrastructure is secure before deployment.

**What Gets Deployed:**
- VPC with public and private subnets
- EC2 instance (t3.micro) running a web application
- S3 bucket for storage
- Security groups and IAM roles
- CloudWatch logging and VPC Flow Logs

---

## Prerequisites

Before you start, you need:

1. **AWS Account** (Free Tier works)
2. **AWS Credentials** (Access Key ID and Secret Access Key)
3. **GitHub Account** (to fork/clone this repo)
4. **Your Public IP Address** (for SSH access)

---

## Part 1: Local Setup

### Step 1: Install Required Tools

**Terraform:**
```bash
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

**AWS CLI:**
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Step 2: Configure AWS Credentials

```bash
aws configure
```

Enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-east-1`
- Default output format: `json`

### Step 3: Get Your IP Address

```bash
curl ifconfig.me
```

Save this IP - you'll need it for SSH access.

---

## Part 2: Deploy Infrastructure Locally

### Step 1: Clone the Repository

```bash
git clone https://github.com/leelee222/iac-demo.git
cd iac-demo
```

### Step 2: Review Configuration

The default configuration is in `variables.tf`. No changes needed unless you want to customize.

### Step 3: Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider and sets up the S3 backend for state storage.

### Step 4: Preview What Will Be Created

```bash
terraform plan
```

You'll see a list of ~25 resources that will be created.

### Step 5: Deploy to AWS

```bash
terraform apply
```

Type `yes` when prompted. Deployment takes about 2-3 minutes.

### Step 6: Get Your Application URL

```bash
terraform output application_url
```

Open this URL in your browser to see your deployed web application.

---

## Part 3: Set Up CI/CD Pipeline

### Step 1: Add GitHub Secrets

Go to your GitHub repository:
1. Click **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these two secrets:

**AWS_ACCESS_KEY_ID**
- Value: Your AWS access key ID

**AWS_SECRET_ACCESS_KEY**
- Value: Your AWS secret access key

### Step 2: Understand the Pipeline

The pipeline runs automatically on every push and includes:

**Security Scans (runs on every push/PR):**
- SAST scanning with Semgrep
- Dependency scanning with Trivy
- Terraform security scanning with Checkov
- Terraform validation and format checks

**Manual Deployment (requires approval):**
- Terraform plan generation
- Plan validation (blocks unsafe changes)
- Terraform apply (only when manually triggered)

### Step 3: Trigger a Deployment

1. Go to **Actions** tab in GitHub
2. Click **IaC Security Scan & AWS Deployment**
3. Click **Run workflow**
4. Set `deploy` to **yes**
5. Click **Run workflow**

The pipeline will:
1. Run all security scans
2. Generate a Terraform plan
3. Validate the plan (block instance type changes)
4. Apply changes to AWS
5. Show deployment summary with application URL

---

## Part 4: Understanding the Workflow

### On Every Push/Pull Request

```
Code Push
    ↓
SAST Scan (Semgrep)
    ↓
Dependency Scan (Trivy)
    ↓
Terraform Security Scan (Checkov)
    ↓
Validation Complete ✓
```

No changes are deployed - only validation happens.

### On Manual Deployment

```
Manual Trigger (deploy=yes)
    ↓
Run All Security Scans
    ↓
Configure AWS Credentials
    ↓
Terraform Plan
    ↓
Validate Plan (block unsafe changes)
    ↓
Upload Plan Artifact
    ↓
Terraform Apply
    ↓
Get Outputs (URLs, IPs)
    ↓
Show Deployment Summary
```

### State Management

- **Local State:** Stored on your machine (when running locally)
- **Remote State:** Stored in S3 bucket `iac-demo-terraform-state-leelee222`
- **State Locking:** Would use DynamoDB (currently disabled due to IAM permissions)

Both local and CI/CD environments share the same remote state in S3.

---

## Part 5: Accessing Your Application

### View the Web Application

```bash
# Get the URL
terraform output application_url

# Or construct it manually
echo "http://$(terraform output -raw public_ip)"
```

Open the URL in your browser. The page shows:
- Deployment status
- Infrastructure details
- Security features enabled
- CI/CD pipeline capabilities

### SSH to the Instance

```bash
# Get the public IP
terraform output public_ip

# SSH using EC2 key (if you have one)
ssh ec2-user@<public-ip>
```

Note: SSH access is restricted to the IP configured in `allowed_ssh_cidr` (default: 10.0.0.0/8).

### Check Application Logs

```bash
# SSH to instance first
ssh ec2-user@<public-ip>

# Check Apache status
sudo systemctl status httpd

# View error logs
sudo tail -f /var/log/httpd/error_log

# View access logs
sudo tail -f /var/log/httpd/access_log
```

---

## Part 6: Making Changes

### Modify Infrastructure

1. Edit Terraform files (e.g., `main.tf`, `variables.tf`)
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to deploy locally
4. Commit and push changes
5. Trigger manual deployment via GitHub Actions

### Update the Application

The web application is deployed via user-data script in `modules/ec2/main.tf`.

To update:
1. Edit the HTML in the `user_data` section
2. Run `terraform apply`
3. Instance will be recreated with new user-data (due to `user_data_replace_on_change = true`)
4. Access the new application URL

### Change Security Rules

To allow HTTP access from anywhere:

```bash
# Update security group
aws ec2 authorize-security-group-ingress \
  --group-id $(terraform output -raw security_group_id) \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0 \
  --region us-east-1
```

Or update `modules/security_group/main.tf` and redeploy.

---

## Part 7: Monitoring and Troubleshooting

### Check Infrastructure Status

```bash
# List all resources in state
terraform state list

# Show details of a specific resource
terraform state show module.ec2_instance.aws_instance.vm

# Check AWS Console
# Go to: https://console.aws.amazon.com/ec2/v2/home?region=us-east-1
```

### View Logs

**VPC Flow Logs:**
```bash
# View in CloudWatch
aws logs tail /aws/vpc/local-flow-logs --follow --region us-east-1
```

**Application Logs (SSH required):**
```bash
ssh ec2-user@<public-ip>
sudo journalctl -u httpd -f
```

### Common Issues

**Application Not Loading:**
- Check security group allows port 80
- Verify instance is running: `aws ec2 describe-instances --instance-ids <id>`
- Check Apache status: `sudo systemctl status httpd` (via SSH)
- Review user-data logs: `sudo cat /var/log/cloud-init-output.log`

**Pipeline Fails:**
- Review GitHub Actions logs
- Check AWS credentials in GitHub Secrets
- Verify S3 backend is accessible
- Look for security scan failures

**State Conflicts:**
- Run `terraform refresh` to sync state with AWS
- Check S3 bucket for state file
- Ensure no concurrent terraform runs

---

## Part 8: Cleanup

### Destroy All Resources

```bash
terraform destroy
```

Type `yes` when prompted. This removes:
- EC2 instance
- VPC and subnets
- Security groups
- S3 bucket (if empty)
- IAM roles
- CloudWatch log groups

**Cost:** Keeping resources running costs approximately $33/month (mainly NAT Gateway).

### Remove State Files

```bash
# Delete S3 state bucket (manual)
aws s3 rb s3://iac-demo-terraform-state-leelee222 --force --region us-east-1

# Delete DynamoDB table (if created)
aws dynamodb delete-table --table-name terraform-state-lock --region us-east-1
```

---

## Part 9: Security Best Practices

This project implements:

**Infrastructure Security:**
- VPC network isolation
- Private subnets for internal resources
- Security groups with minimal access
- SSH restricted to specific IPs
- IMDSv2 enforced on EC2
- EBS volume encryption
- S3 bucket public access blocked

**Code Security:**
- SAST scanning (Semgrep)
- Dependency scanning (Trivy)
- IaC security scanning (Checkov)
- Automated pipeline blocking on failures

**Operational Security:**
- Remote state storage (S3)
- IAM roles instead of hardcoded credentials
- CloudWatch logging enabled
- VPC Flow Logs for traffic monitoring
- Manual deployment approval required

---

## Part 10: Next Steps

**Enhance Security:**
- Add KMS encryption for S3 and CloudWatch
- Increase CloudWatch log retention
- Enable MFA for AWS account
- Use secrets manager for sensitive data

**Improve Pipeline:**
- Add automated testing
- Implement blue-green deployments
- Add deployment notifications (Slack, email)
- Create staging environment

**Scale Infrastructure:**
- Add auto-scaling for EC2
- Use Application Load Balancer
- Deploy to multiple availability zones
- Add RDS database

**Monitor Better:**
- Set up CloudWatch alarms
- Create custom dashboards
- Implement distributed tracing
- Add performance monitoring

---

## Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Checkov Documentation](https://www.checkov.io/)
- Project Documentation:
  - [README.md](README.md) - Project overview

---

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review GitHub Actions logs
3. Inspect AWS Console for resource state
4. Check Terraform state: `terraform state list`
5. Review project documentation files

**Remember:** This is a learning project. Experiment, break things, and learn from them.
