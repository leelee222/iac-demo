# 🏗️ Infrastructure as Code (IaC) Demo

A hands-on project to learn **Infrastructure as Code** and **Cloud Security** using Terraform, security scanning tools, and cloud deployments.
This repo is part of my **3-Month DevSecOps Journey - Month 2**.

---

## 📅 Roadmap Progress

### 🔄 Week 5 – IaC Basics

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
* [ ] Automate IaC scans in CI/CD pipeline
* [ ] Test pipeline blocking insecure IaC deployments
* [ ] Push code to GitHub
* [ ] Document IaC security workflow

---

### Week 7 – Cloud Security Basics

* [ ] Create free-tier account on AWS/GCP/Azure
* [ ] Set up IAM roles and permissions
* [ ] Deploy your Terraform VM + bucket in cloud
* [ ] Enable logging (CloudTrail/CloudWatch)
* [ ] Test access restrictions & logs
* [ ] Add minor security hardening (firewall rules, VPC)
* [ ] Document cloud security setup

---

### Week 8 – Cloud Deployment Project

* [ ] Integrate CI/CD pipeline with cloud deployment
* [ ] Automate Terraform apply in pipeline
* [ ] Add automated security scans (SAST, dependency) in pipeline
* [ ] Deploy app to cloud via pipeline
* [ ] Test security failures and pipeline blocking
* [ ] Push final cloud deployment to GitHub
* [ ] Document full cloud deployment workflow

---

## ⚙️ Tech Stack

* **IaC Tool**: Terraform v5.100.0
* **Provider**: AWS (LocalStack for local testing)
* **Local Testing**: LocalStack v4.10.1
* **Security Tools**: Checkov, Terraform Sentinel, tfsec (coming in Week 6)
* **CI/CD**: GitHub Actions (coming in Week 8)
* **Modules**: Custom modules for EC2, S3, Security Groups
* **Logging & Monitoring**: CloudTrail, CloudWatch


---

## 🛡️ Security Best Practices

This project follows IaC security best practices:

### Infrastructure Security
- All storage buckets are private by default
- IAM roles follow principle of least privilege
- Security groups restrict access to necessary ports only
- Encryption enabled for storage and data in transit

### Code Security
- IaC scripts scanned with **Checkov** for misconfigurations
- Security policies enforced with **Terraform Sentinel**
- Automated scanning in CI/CD pipeline
- Pipeline fails on critical security issues

### Cloud Security
- Multi-factor authentication (MFA) enabled
- CloudTrail logging enabled for audit trails
- CloudWatch alerts configured for suspicious activity
- VPC network isolation implemented

---

## 🚀 Quick Start

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

# Install LocalStack (for local testing)
pip install localstack
# or
brew install localstack
```

### Deploy Infrastructure

```bash
# 1. Start LocalStack (for local testing)
localstack start -d

# 2. Initialize Terraform
terraform init

# 3. Validate configuration
terraform validate

# 4. Plan deployment
terraform plan

# 5. Apply infrastructure
terraform apply

# 6. View outputs
terraform output

# 7. Run automated tests
bash test-infrastructure.sh

# 8. Destroy infrastructure
terraform destroy
```

### Using Variables

Create a `terraform.tfvars` file to customize:
```hcl
aws_region     = "us-east-1"
instance_type  = "t2.micro"
bucket_prefix  = "my-project"
```

---

## 📁 Project Structure

```
iac-demo/
├── main.tf                      # Main Terraform configuration
├── provider.tf                  # AWS provider configuration
├── variables.tf                 # Variable definitions
├── outputs.tf                   # Output values
├── terraform.tfvars.example     # Example variable values
├── .gitignore                   # Git ignore rules
├── test-infrastructure.sh       # Automated test script
├── TESTING.md                   # Testing documentation
├── README.md                    # This file
└── modules/                     # Reusable Terraform modules
    ├── ec2/                     # EC2 instance module
    │   ├── main.tf              # EC2 resource definition
    │   ├── variables.tf         # Module inputs
    │   └── outputs.tf           # Module outputs
    ├── s3_bucket/               # S3 bucket module
    │   ├── main.tf              # S3 resource definition
    │   ├── variables.tf         # Module inputs
    │   └── outputs.tf           # Module outputs
    └── security_group/          # Security group module
        ├── main.tf              # Security group definition
        ├── variables.tf         # Module inputs
        └── outputs.tf           # Module outputs
```

---

## 🏗️ Infrastructure Components

This project deploys the following infrastructure:

### 1. **EC2 Instance Module** (`modules/ec2/`)
- Creates a virtual machine with configurable instance type
- Attached to security group for network access control
- Tagged with customizable names

### 2. **S3 Bucket Module** (`modules/s3_bucket/`)
- Creates object storage with unique random suffix
- Environment tagging for resource organization
- Follows naming best practices

### 3. **Security Group Module** (`modules/security_group/`)
- Defines firewall rules for the EC2 instance
- Allows SSH (port 22) and HTTP (port 80) ingress
- Allows all egress traffic

### Module Dependencies
```
security_group → ec2_instance
     (sg_id)
```
The EC2 module depends on the Security Group module, demonstrating inter-module communication.

---

## 🧪 Testing

### Automated Testing
Run the comprehensive test suite:
```bash
bash test-infrastructure.sh
```

This runs 22 automated tests covering:
- ✅ Configuration validation
- ✅ File structure verification
- ✅ Module organization
- ✅ State verification
- ✅ Output validation
- ✅ Variable definitions
- ✅ Module dependencies

### Manual Testing
See [TESTING.md](TESTING.md) for detailed testing instructions including:
- Validation tests
- State verification
- Output checks
- LocalStack verification
- Troubleshooting guide

---

## 📊 Current Infrastructure

After running `terraform apply`, the following resources are created:

| Resource Type | Module | Name/ID | Purpose |
|--------------|--------|---------|---------|
| EC2 Instance | `ec2_instance` | `i-xxxxxxxxx` | Virtual machine |
| S3 Bucket | `s3_bucket` | `iac-demo-local-xxxxx` | Object storage |
| Security Group | `security_group` | `sg-xxxxxxxxx` | Network security |
| Random ID | `s3_bucket` | Random suffix | Unique bucket naming |

**Total Resources**: 4 (3 main + 1 helper)

---

## 🔍 Security Scanning (Week 6)

Coming in Week 6 - IaC Security:

```bash
# Install Checkov
pip install checkov

# Scan Terraform files
checkov -d .

# Scan specific file
checkov -f main.tf

# Install tfsec
brew install tfsec

# Run tfsec scan
tfsec .
```

---

## 📝 Documentation

- [Terraform Documentation](https://www.terraform.io/docs)
- [Checkov Documentation](https://www.checkov.io/)
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)
- [Cloud Security Fundamentals](https://cloud.google.com/security/best-practices)

---

## 🎯 Learning Goals

- ✅ Master Infrastructure as Code with Terraform
- ✅ Create reusable Terraform modules
- ✅ Implement module dependencies and composition
- ✅ Use variables for configuration management
- ✅ Test infrastructure with automated scripts
- ⏳ Implement security scanning and policy enforcement (Week 6)
- ⏳ Deploy secure cloud infrastructure (Week 7)
- ⏳ Automate infrastructure deployment with CI/CD (Week 8)
- ⏳ Apply cloud security best practices
- ⏳ Monitor and audit cloud resources

---

## 🎓 What I Learned (Week 5)

### Module Architecture
- How to create reusable Terraform modules
- Structuring modules with `main.tf`, `variables.tf`, `outputs.tf`
- Passing data between modules using outputs and inputs
- Creating module dependencies (security_group → ec2)

### Variables & Configuration
- Defining variables with types and descriptions
- Setting default values
- Using `terraform.tfvars` for customization
- Variable validation and best practices

### Testing & Validation
- Writing automated test scripts
- Using `terraform validate` and `terraform plan`
- Verifying state and outputs
- LocalStack for local infrastructure testing

### Best Practices
- ✅ Modular code organization
- ✅ DRY (Don't Repeat Yourself) principle
- ✅ Proper `.gitignore` configuration
- ✅ Documentation and testing
- ✅ Version control with Git

---

## 📈 Progress Tracking

**Week 5 Status**: ✅ **COMPLETE** (7/7 tasks)

Ready to start **Week 6 - IaC Security**! 🚀
