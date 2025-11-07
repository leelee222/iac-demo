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
* [ ] Document IaC project

---

### Week 6 – IaC Security

* [ ] Install Checkov or Terraform Sentinel
* [ ] Run security scans on IaC scripts
* [ ] Fix detected misconfigurations (e.g., public buckets)
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

* **IaC Tool**: Terraform
* **Cloud Provider**: AWS / GCP / Azure (free tier)
* **Security Tools**: Checkov, Terraform Sentinel, tfsec
* **CI/CD**: GitHub Actions
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

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply

# Destroy infrastructure
terraform destroy
```

---

## 📁 Project Structure

```
iac-demo/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── outputs.tf          # Output values
├── modules/            # Reusable Terraform modules
│   ├── vm/
│   └── storage/
├── .github/
│   └── workflows/      # CI/CD pipeline definitions
└── README.md
```

---

## 🔍 Security Scanning

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

- Master Infrastructure as Code with Terraform
- Implement security scanning and policy enforcement
- Deploy secure cloud infrastructure
- Automate infrastructure deployment with CI/CD
- Apply cloud security best practices
- Monitor and audit cloud resources
