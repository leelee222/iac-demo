# Infrastructure as Code (IaC) Demo

A hands-on project to learn Infrastructure as Code and Cloud Security using Terraform, security scanning tools, and AWS cloud deployments.
This repository is part of my 3-Month DevSecOps Journey - Month 2.

**Status**: ✅ **DEPLOYED TO PRODUCTION AWS** - Full infrastructure running in real AWS with enterprise-grade security.

---

## Roadmap Progress

### Week 5 - IaC Basics

* [x] Install Terraform/Ansible and configure CLI
* [x] Write Terraform script for a simple VM
* [x] Add storage bucket in Terraform
* [x] Test local deployment (or cloud free tier)
* [x] Learn modules and variables in Terraform
* [x] Refactor code using modules
* [x] Document IaC project

---

### Week 6 – IaC Security

* [x] Install Checkov or Terraform Sentinel
* [x] Run security scans on IaC scripts
* [x] Fix detected misconfigurations (e.g., public buckets)
* [x] Automate IaC scans in CI/CD pipeline
* [x] Test pipeline blocking insecure IaC deployments
* [x] Push code to GitHub
* [x] Document IaC security workflow

---

### Week 7 - Cloud Security Basics (AWS Production)

**Deployed to Real AWS** with full production infrastructure

* [x] Set up IAM roles and policies
* [x] Create VPC and network security
* [x] Deploy infrastructure with VPC isolation
* [x] Enable CloudWatch logging & VPC Flow Logs
* [x] Configure security groups with IP restrictions
* [x] Implement advanced security hardening
* [x] Deploy to production AWS

---

### Week 8 - Cloud Deployment Project

* [x] Integrate CI/CD pipeline with cloud deployment
* [ ] Automate Terraform apply in pipeline
* [ ] Add automated security scans (SAST, dependency) in pipeline
* [ ] Deploy app to cloud via pipeline
* [ ] Test security failures and pipeline blocking
* [ ] Push final cloud deployment to GitHub
* [ ] Document full cloud deployment workflow

---

## Tech Stack

* **IaC Tool**: Terraform v5.100.0
* **Provider**: AWS (Production Deployment)
* **Cloud Platform**: Amazon Web Services (AWS Free Tier + Credits)
* **Security Tools**: Checkov v3.2.490
* **CI/CD**: GitHub Actions
* **Modules**: Custom modules for EC2, S3, Security Groups, IAM, VPC
* **Logging & Monitoring**: CloudWatch Logs & VPC Flow Logs
* **Instance Type**: t3.micro (Free Tier Eligible)
* **Region**: us-east-1

**Status**: Deployed to production AWS with full enterprise security features.

---

## Security Best Practices

This project follows IaC security best practices:

### Infrastructure Security
- ✅ All storage buckets are private by default
- ✅ S3 public access blocked
- ✅ S3 versioning enabled
- ✅ IAM roles follow principle of least privilege
- ✅ Security groups restrict access to necessary ports only
- ✅ SSH access restricted to specific IP (41.85.163.81/32)
- ✅ Encryption enabled for storage (EBS encryption)
- ✅ IMDSv2 enforced on EC2 instances
- ✅ VPC network isolation (public/private subnets)
- ✅ NAT Gateway for private subnet outbound access
- ✅ Network ACLs for subnet-level firewall
- ✅ VPC Flow Logs for traffic monitoring

### Code Security
- ✅ IaC scripts scanned with **Checkov** for misconfigurations
- ✅ Automated scanning in CI/CD pipeline
- ✅ Pipeline fails on critical security issues
- ✅ 100% security scan pass rate

### Cloud Security
- ✅ VPC network isolation (public/private subnets)
- ✅ IAM roles and policies (least privilege)
- ✅ VPC Flow Logs enabled (CloudWatch)
- ✅ Network ACLs (subnet-level firewall)
- ✅ NAT Gateway for secure private subnet access
- ✅ CloudWatch logging enabled
- ✅ Production AWS deployment complete

---

## Quick Start

### Prerequisites
```bash
# Install Terraform
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify installation
terraform --version

# Configure AWS CLI
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: us-east-1
# Default output format: json

# Install Checkov (security scanning)
pip install checkov
# or
brew install checkov
```

### Deploy to AWS

```bash
# 1. Configure your IP for SSH access
# Edit terraform.tfvars and set your IP address

# 2. Initialize Terraform
terraform init

# 3. Run security scan
checkov -d . --compact

# 4. Preview deployment
terraform plan

# 5. Deploy infrastructure
terraform apply

# 6. View outputs
terraform output

# 7. When done, destroy resources to save costs
terraform destroy
```

### Using Variables

Create a `terraform.tfvars` file to customize:
```hcl
aws_region        = "us-east-1"
instance_type     = "t3.micro"  # Free tier eligible
bucket_prefix     = "my-project-unique-name"  # Must be globally unique
allowed_ssh_cidr  = ["YOUR_IP/32"]  # Replace with your IP
```

**Get your IP:** `curl ifconfig.me`

---

## Project Structure

```
iac-demo/
├── main.tf                      # Main Terraform configuration
├── provider.tf                  # AWS provider configuration
├── variables.tf                 # Variable definitions
├── outputs.tf                   # Output values
├── terraform.tfvars             # Your custom variables
├── .gitignore                   # Git ignore rules
├── TESTING.md                   # Testing documentation
├── JUNIOR-DEVSECOPS-GUIDE.md    # Beginner-friendly guide
├── README.md                    # This file
├── .github/
│   └── workflows/
│       ├── security-scan.yml    # CI/CD security pipeline
│       └── test-blocking.yml    # Pipeline blocking test
└── modules/                     # Reusable Terraform modules
    ├── vpc/                     # VPC module (NEW!)
    │   ├── main.tf              # VPC, subnets, gateways, flow logs
    │   ├── variables.tf         # Module inputs
    │   └── outputs.tf           # Module outputs
    ├── iam/                     # IAM module (NEW!)
    │   ├── main.tf              # IAM roles and policies
    │   ├── variables.tf         # Module inputs
    │   └── outputs.tf           # Module outputs
    ├── ec2/                     # EC2 instance module
    │   ├── main.tf              # EC2 resource definition
    │   ├── variables.tf         # Module inputs
    │   └── outputs.tf           # Module outputs
    ├── s3_bucket/               # S3 bucket module
    │   ├── main.tf              # S3 with security hardening
    │   ├── variables.tf         # Module inputs
    │   └── outputs.tf           # Module outputs
    └── security_group/          # Security group module
        ├── main.tf              # Firewall rules
        ├── variables.tf         # Module inputs
        └── outputs.tf           # Module outputs
```

---

## Infrastructure Components

This project deploys the following infrastructure:

### 1. VPC Module (`modules/vpc/`) - NEW

- Creates isolated network with public and private subnets
- **Components**:
  - VPC with CIDR 10.0.0.0/16 (65,536 IPs)
  - Public subnet (10.0.1.0/24) for internet-facing resources
  - Private subnet (10.0.2.0/24) for internal resources
  - Internet Gateway for public subnet
  - NAT Gateway for private subnet outbound access
  - Route tables for traffic routing
  - Network ACL for subnet-level firewall
  - VPC Flow Logs for traffic monitoring
- **Security Benefits**:
  - Network isolation from other AWS resources
  - Private subnet has no direct internet access
  - Defense in depth with NACL + Security Groups
  - Traffic monitoring and logging

### 2. IAM Module (`modules/iam/`) - NEW

- Creates IAM roles and policies for EC2 instances
- **Components**:
  - IAM role with EC2 trust policy
  - CloudWatch Logs policy (write logs only)
  - S3 read-only policy (scoped to specific bucket)
  - Instance profile for EC2 attachment
- **Security Principles**:
  - Principle of least privilege
  - No hardcoded credentials
  - Scoped permissions (only specific resources)

### 3. EC2 Instance Module (`modules/ec2/`)
- Creates a virtual machine with configurable instance type
- **Security Features**:
  - IMDSv2 enforced (prevents SSRF attacks)
  - Root volume encryption enabled
  - Detailed monitoring enabled
  - EBS optimization enabled
  - IAM role attached (no credentials needed)
  - Deployed in VPC subnet
- Attached to security group for network access control
- Tagged with customizable names

### 4. S3 Bucket Module (`modules/s3_bucket/`)
- Creates object storage with unique random suffix
- **Security Features**:
  - Public access completely blocked
  - Versioning enabled for data recovery
  - Private by default
- Environment tagging for resource organization
- Follows naming best practices

### 5. Security Group Module (`modules/security_group/`)
- Defines firewall rules for the EC2 instance
- **Security Features**:
  - SSH restricted to specific IP ranges (not 0.0.0.0/0)
  - HTTP open for web traffic (acceptable for web servers)
  - Egress limited to HTTP/HTTPS/DNS only
  - All rules have descriptions
  - Attached to VPC for network isolation
- Configurable allowed IP ranges

### Module Dependencies
```
VPC → Security Group → EC2
        ↓
      (VPC subnet, sg_id)

S3 Bucket → IAM → EC2
             ↓
       (bucket_name, instance_profile)
```
The EC2 module depends on the Security Group module, demonstrating inter-module communication.

---

## Testing

### Automated Testing
Run the comprehensive test suite:
```bash
bash test-infrastructure.sh
```

This runs 22 automated tests covering:
- Configuration validation
- File structure verification
- Module organization
- State verification
- Output validation
- Variable definitions
- Module dependencies

### Security Scanning
```bash
# Run Checkov security scan
checkov -d . --compact

# Current results:
# 14 checks passed
# 0 checks failed
# Success rate: 100%
```

### Manual Testing
See [TESTING.md](TESTING.md) for detailed testing instructions including:
- Validation tests
- State verification
- Output checks
- LocalStack verification
- Troubleshooting guide

---

## Current Infrastructure

After running `terraform apply`, the following resources are created:

| Resource Type | Module | Name/ID | Purpose |
|--------------|--------|---------|---------|
| **Networking (VPC)** | | | |
| VPC | `vpc` | `vpc-xxxxxxxxx` | Isolated network (10.0.0.0/16) |
| Public Subnet | `vpc` | `subnet-xxxxxxxxx` | Internet-facing resources (10.0.1.0/24) |
| Private Subnet | `vpc` | `subnet-xxxxxxxxx` | Internal resources (10.0.2.0/24) |
| Internet Gateway | `vpc` | `igw-xxxxxxxxx` | Public internet access |
| NAT Gateway | `vpc` | `nat-xxxxxxxxx` | Private outbound access |
| Elastic IP | `vpc` | `eip-xxxxxxxxx` | Static IP for NAT |
| Route Tables | `vpc` | 2 tables | Traffic routing |
| Route Table Associations | `vpc` | 2 associations | Link tables to subnets |
| Network ACL | `vpc` | `acl-xxxxxxxxx` | Subnet-level firewall |
| **IAM & Security** | | | |
| IAM Role | `iam` | `iac-demo-ec2-role` | EC2 permissions |
| IAM Policies | `iam` | 2 policies | CloudWatch + S3 access |
| IAM Instance Profile | `iam` | `iac-demo-ec2-role-profile` | Attach role to EC2 |
| IAM Flow Logs Role | `vpc` | `local-vpc-flow-logs-role` | VPC logging permissions |
| IAM Flow Logs Policy | `vpc` | Inline policy | Define log permissions |
| Security Group | `security_group` | `sg-xxxxxxxxx` | Instance firewall |
| **Compute & Storage** | | | |
| EC2 Instance | `ec2_instance` | `i-xxxxxxxxx` | Virtual machine (secured, with IAM) |
| S3 Bucket | `s3_bucket` | `iac-demo-local-xxxxx` | Object storage (private) |
| S3 Public Access Block | `s3_bucket` | Auto-generated | Prevents public access |
| S3 Versioning | `s3_bucket` | Enabled | Data recovery |
| Random ID | `s3_bucket` | Random suffix | Unique bucket naming |

**Total Resources**: 22 (13 VPC + 5 IAM + 4 Storage/Compute)

---

## Security Features

### Week 6 Achievements (COMPLETE)

#### Security Scanning
- ✅ Checkov v3.2.490 installed and configured
- ✅ 8 initial vulnerabilities identified
- ✅ 100% of security issues fixed
- ✅ Automated CI/CD security pipeline
- ✅ Pipeline blocks insecure deployments

#### Security Hardening Applied
1. **EC2 Security**:
   - IMDSv2 enforcement
   - Root volume encryption
   - Detailed monitoring
   - EBS optimization

2. **Network Security**:
   - SSH restricted to specific IPs
   - Security group rule descriptions
   - Limited egress traffic

3. **Storage Security**:
   - S3 public access block
   - Bucket versioning
   - Private by default

#### CI/CD Security
- GitHub Actions workflow for automated scanning
- Scans run on every push and pull request
- Pipeline fails if security issues found
- Documented security workflow

**Security Scan Results**: 100% Pass Rate

---

## Documentation

- [TESTING.md](TESTING.md) - Comprehensive testing guide
- [SECURITY-WORKFLOW.md](SECURITY-WORKFLOW.md) - Security implementation details
## Documentation

- [CI-CD-DEPLOYMENT.md](CI-CD-DEPLOYMENT.md) - Complete CI/CD pipeline integration with AWS deployment
- [CLOUD-SECURITY-SETUP.md](CLOUD-SECURITY-SETUP.md) - Complete cloud security architecture documentation
- [TESTING.md](TESTING.md) - Comprehensive testing guide
- [JUNIOR-DEVSECOPS-GUIDE.md](JUNIOR-DEVSECOPS-GUIDE.md) - Beginner-friendly explanation of everything
- [VPC-EXPLAINED.md](VPC-EXPLAINED.md) - VPC and network security deep dive
- [IaC-security-workflow.md](IaC-security-workflow.md) - Security implementation details
- [CI-CD-SECURITY.md](CI-CD-SECURITY.md) - CI/CD pipeline security
- [Terraform Documentation](https://www.terraform.io/docs)
- [Checkov Documentation](https://www.checkov.io/)
- [AWS Documentation](https://docs.aws.amazon.com/)

---

## Learning Goals

- ✅ Master Infrastructure as Code with Terraform
- ✅ Create reusable Terraform modules
- ✅ Implement module dependencies and composition
- ✅ Use variables for configuration management
- ✅ Implement security scanning and policy enforcement
- ✅ Fix security misconfigurations
- ✅ Automate security in CI/CD pipeline
- ✅ Implement IAM roles and policies
- ✅ Create VPC and network security
- ✅ Deploy secure cloud infrastructure to AWS
- ✅ Enable logging and monitoring (CloudWatch & VPC Flow Logs)
- ✅ Apply advanced cloud security (IMDSv2, encryption, etc.)
- ✅ Production AWS deployment

---

## What I Learned

### Week 5 - IaC Basics (COMPLETE)

**Module Architecture**
- How to create reusable Terraform modules
- Structuring modules with `main.tf`, `variables.tf`, `outputs.tf`
- Passing data between modules using outputs and inputs
- Creating module dependencies (security_group → ec2)

**Variables & Configuration**
- Defining variables with types and descriptions
- Setting default values
- Using `terraform.tfvars` for customization
- Variable validation and best practices

**Testing & Validation**
- Writing test infrastructure scripts
- Using `terraform validate` and `terraform plan`
- Verifying state and outputs
- Real AWS deployment and validation

### Week 6 - IaC Security (COMPLETE)

**Security Scanning**
- Installing and configuring Checkov
- Running comprehensive security scans
- Identifying vulnerabilities in IaC code
- Understanding security check results

**Security Hardening**
- Enforcing IMDSv2 on EC2 instances
- Implementing encryption at rest
- Restricting network access (SSH, egress)
- Blocking S3 public access
- Enabling S3 versioning

**CI/CD Security Automation**
- Creating GitHub Actions workflows
- Automating security scans on push/PR
- Implementing pipeline blocking on security failures
- Testing with intentionally insecure code

**Security Best Practices**
- Defense in depth principle
- Principle of least privilege
- Secure by default configuration
- Documentation of security decisions
- Automation of security checks

### Week 7 - Cloud Security & AWS Production (COMPLETE)

**IAM Implementation**
- Created IAM role for EC2 instances
- Implemented instance profile for secure access
- Configured trust relationships and policies
- Applied least privilege access principles

**VPC and Network Security**
- Deployed production VPC with public/private subnets
- Configured Internet Gateway and NAT Gateway
- Implemented route tables for proper traffic flow
- Set up VPC Flow Logs for network monitoring
- Created CloudWatch Log Group for centralized logging

**AWS Production Deployment**
- Successfully deployed 25 resources to AWS Free Tier
- Configured real AWS credentials and region (us-east-1)
- Used Amazon Linux 2023 AMI (ami-0f00d706c4a80fd93)
- Deployed t3.micro instance (free tier eligible)
- Enabled EBS optimization and detailed monitoring
- Configured cost-effective infrastructure (~$33/month)

**Security Features Enabled**
- IMDSv2 enforcement on EC2
- Encryption at rest for all volumes
- Restricted SSH access to specific IP
- VPC Flow Logs for network traffic analysis
- CloudWatch monitoring and logging
- Security group with minimal required ports

---

## Progress Tracking

**Week 5 Status**: COMPLETE (7/7 tasks)  
**Week 6 Status**: COMPLETE (7/7 tasks)  
**Week 7 Status**: COMPLETE (7/7 tasks)

**Overall Progress**: 21/28 tasks complete (75%)

Currently working on Week 8 advanced topics.

---

