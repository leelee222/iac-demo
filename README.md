# 🏗️ Infrastructure as Code (IaC) Demo

A hands-on project to learn **Infrastructure as Code** and **Cloud Security** using Terraform, security scanning tools, and cloud deployments.
This repo is part of my **3-Month DevSecOps Journey - Month 2**.

> **Note**: Using **LocalStack** for AWS simulation as AWS account signup is pending approval. All concepts and practices remain the same and can be deployed to real AWS/GCP/Azure later.

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
* [x] Automate IaC scans in CI/CD pipeline
* [x] Test pipeline blocking insecure IaC deployments
* [x] Push code to GitHub
* [x] Document IaC security workflow

---

### Week 7 – Cloud Security Basics (LocalStack Edition)

> **Using LocalStack** for local AWS simulation (AWS account approval pending)

* [x] Set up IAM roles and policies (LocalStack)
* [ ] Create VPC and network security
* [ ] Deploy infrastructure with VPC isolation
* [ ] Enable CloudWatch logging (simulated)
* [ ] Test access restrictions & security groups
* [ ] Add advanced security hardening
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
* [ ] (Optional) Deploy to real AWS/GCP/Azure if account approved

---

## ⚙️ Tech Stack

* **IaC Tool**: Terraform v5.100.0
* **Provider**: AWS (via LocalStack for local testing)
* **Local Testing**: LocalStack v4.10.1 (simulates AWS services)
* **Security Tools**: Checkov v3.2.490
* **CI/CD**: GitHub Actions
* **Modules**: Custom modules for EC2, S3, Security Groups, IAM, VPC
* **Logging & Monitoring**: CloudWatch (LocalStack simulated)

> **Why LocalStack?** AWS account signup issues (phone verification). LocalStack provides a complete AWS cloud environment locally, allowing me to learn and practice all cloud security concepts without a real AWS account.

---

## 🛡️ Security Best Practices

This project follows IaC security best practices:

### Infrastructure Security
- ✅ All storage buckets are private by default
- ✅ S3 public access blocked
- ✅ S3 versioning enabled
- ✅ IAM roles follow principle of least privilege
- ✅ Security groups restrict access to necessary ports only
- ✅ SSH access restricted to specific IP ranges (not 0.0.0.0/0)
- ✅ Encryption enabled for storage (EBS encryption)
- ✅ IMDSv2 enforced on EC2 instances

### Code Security
- ✅ IaC scripts scanned with **Checkov** for misconfigurations
- ✅ Automated scanning in CI/CD pipeline
- ✅ Pipeline fails on critical security issues
- ✅ 100% security scan pass rate

### Cloud Security
- ⏳ VPC network isolation (Week 7)
- ⏳ IAM roles and policies (Week 7)
- ⏳ CloudWatch logging (Week 7)
- ⏳ Network ACLs and security hardening (Week 7)

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

# Install LocalStack (for local AWS simulation)
pip install localstack
# or
brew install localstack

# Install Checkov (security scanning)
pip install checkov
# or
brew install checkov
```

### Deploy Infrastructure

```bash
# 1. Start LocalStack (simulates AWS locally)
localstack start -d

# 2. Initialize Terraform
terraform init

# 3. Run security scan
checkov -d . --compact

# 4. Validate configuration
terraform validate

# 5. Plan deployment
terraform plan

# 6. Apply infrastructure
terraform apply

# 7. View outputs
terraform output

# 8. Run automated tests
bash test-infrastructure.sh

# 9. Destroy infrastructure
terraform destroy
```

### Using Variables

Create a `terraform.tfvars` file to customize:
```hcl
aws_region        = "us-east-1"
instance_type     = "t2.micro"
bucket_prefix     = "my-project"
allowed_ssh_cidr  = "YOUR_IP/32"  # Replace with your IP
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
├── SECURITY-WORKFLOW.md         # Security documentation
├── README.md                    # This file
├── .github/
│   └── workflows/
│       ├── security-scan.yml    # CI/CD security pipeline
│       └── test-insecure.yml    # Pipeline blocking test
└── modules/                     # Reusable Terraform modules
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

## 🏗️ Infrastructure Components

This project deploys the following infrastructure:

### 1. **EC2 Instance Module** (`modules/ec2/`)
- Creates a virtual machine with configurable instance type
- **Security Features**:
  - ✅ IMDSv2 enforced (prevents SSRF attacks)
  - ✅ Root volume encryption enabled
  - ✅ Detailed monitoring enabled
  - ✅ EBS optimization enabled
- Attached to security group for network access control
- Tagged with customizable names

### 2. **S3 Bucket Module** (`modules/s3_bucket/`)
- Creates object storage with unique random suffix
- **Security Features**:
  - ✅ Public access completely blocked
  - ✅ Versioning enabled for data recovery
  - ✅ Private by default
- Environment tagging for resource organization
- Follows naming best practices

### 3. **Security Group Module** (`modules/security_group/`)
- Defines firewall rules for the EC2 instance
- **Security Features**:
  - ✅ SSH restricted to specific IP ranges (not 0.0.0.0/0)
  - ✅ HTTP open for web traffic (acceptable for web servers)
  - ✅ Egress limited to HTTP/HTTPS/DNS only
  - ✅ All rules have descriptions
- Configurable allowed IP ranges

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

### Security Scanning
```bash
# Run Checkov security scan
checkov -d . --compact

# Current results:
# ✅ 14 checks passed
# ❌ 0 checks failed
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

## 📊 Current Infrastructure

After running `terraform apply`, the following resources are created:

| Resource Type | Module | Name/ID | Purpose |
|--------------|--------|---------|---------|
| EC2 Instance | `ec2_instance` | `i-xxxxxxxxx` | Virtual machine (secured) |
| S3 Bucket | `s3_bucket` | `iac-demo-local-xxxxx` | Object storage (private) |
| S3 Public Access Block | `s3_bucket` | Auto-generated | Prevents public access |
| S3 Versioning | `s3_bucket` | Enabled | Data recovery |
| Security Group | `security_group` | `sg-xxxxxxxxx` | Network security (restricted) |
| Random ID | `s3_bucket` | Random suffix | Unique bucket naming |

**Total Resources**: 6 (4 main + 2 security)

---

## � Security Features

### Week 6 Achievements (✅ COMPLETE)

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

**Security Scan Results**: ✅ **100% Pass Rate**

---

## 📝 Documentation

- [TESTING.md](TESTING.md) - Comprehensive testing guide
- [SECURITY-WORKFLOW.md](SECURITY-WORKFLOW.md) - Security implementation details
- [Terraform Documentation](https://www.terraform.io/docs)
- [Checkov Documentation](https://www.checkov.io/)
- [LocalStack Documentation](https://docs.localstack.cloud/)

---

## 🎯 Learning Goals

- ✅ Master Infrastructure as Code with Terraform
- ✅ Create reusable Terraform modules
- ✅ Implement module dependencies and composition
- ✅ Use variables for configuration management
- ✅ Test infrastructure with automated scripts
- ✅ Implement security scanning and policy enforcement
- ✅ Fix security misconfigurations
- ✅ Automate security in CI/CD pipeline
- ⏳ Implement IAM roles and policies (Week 7)
- ⏳ Create VPC and network security (Week 7)
- ⏳ Deploy secure cloud infrastructure (Week 7)
- ⏳ Enable logging and monitoring (Week 7)
- ⏳ Apply advanced cloud security (Week 7)

---

## 🎓 What I Learned

### Week 5 - IaC Basics (✅ COMPLETE)

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
- Writing automated test scripts
- Using `terraform validate` and `terraform plan`
- Verifying state and outputs
- LocalStack for local infrastructure testing

### Week 6 - IaC Security (✅ COMPLETE)

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

---

## 📈 Progress Tracking

**Week 5 Status**: ✅ **COMPLETE** (7/7 tasks)  
**Week 6 Status**: ✅ **COMPLETE** (7/7 tasks)  
**Week 7 Status**: ⏳ **READY TO START** (0/7 tasks)

**Overall Progress**: 14/28 tasks complete (50%)

Ready to start **Week 7 - Cloud Security Basics** (using LocalStack)! 🚀

---

## 🚀 Next Steps (Week 7)

With LocalStack, we'll implement:

1. **IAM Roles and Policies** - Create proper access control
2. **VPC and Networking** - Implement network isolation
3. **CloudWatch Logging** - Enable infrastructure monitoring
4. **Advanced Security Groups** - Multi-tier network security
5. **Security Hardening** - Additional security controls
6. **Documentation** - Complete cloud security guide

---

## 💡 Why LocalStack?

**Current Situation**: AWS account signup pending (phone verification issues)

**LocalStack Benefits**:
- ✅ Complete AWS cloud environment locally
- ✅ Learn all cloud security concepts
- ✅ Practice without cost
- ✅ Same Terraform code works on real AWS
- ✅ Faster development and testing
- ✅ No AWS account needed

