# Cloud Security Setup Documentation

## Overview

This document details the comprehensive security architecture implemented in this AWS infrastructure deployment. The setup follows defense-in-depth principles with multiple layers of security controls.

## Infrastructure Overview

**Deployment Region**: us-east-1  
**Account ID**: 473550160619  
**Deployment Date**: November 2025  
**Total Resources**: 25 AWS resources  
**Cost**: ~$33/month (NAT Gateway: $32/month, rest free tier eligible)

## Security Architecture

### 1. Network Security

#### VPC Isolation
- **VPC**: vpc-008c829789c18098b
- **CIDR Block**: 10.0.0.0/16
- **Purpose**: Complete network isolation from other AWS resources and the internet

```
Network Layout:
├── Public Subnet (10.0.1.0/24)
│   ├── Internet Gateway attached
│   ├── EC2 instances with public IPs
│   └── Direct internet access
└── Private Subnet (10.0.2.0/24)
    ├── NAT Gateway for outbound only
    ├── No direct internet access
    └── Isolated backend resources
```

#### Subnets
- **Public Subnet**: subnet-0e1696350a3592c7d
  - Used for: Web servers, bastion hosts
  - Internet access: Bidirectional via Internet Gateway
  
- **Private Subnet**: subnet-0aeb4f9ba503f916c
  - Used for: Databases, application servers
  - Internet access: Outbound only via NAT Gateway (54.225.29.80)

#### Network ACLs
Stateless firewall at subnet level:

**Inbound Rules**:
- HTTP (80): 0.0.0.0/0
- HTTPS (443): 0.0.0.0/0
- SSH (22): 41.85.163.81/32 (restricted to trusted IP)
- Ephemeral ports (1024-65535): 0.0.0.0/0 (return traffic)

**Outbound Rules**:
- All traffic: 0.0.0.0/0

#### Security Groups
Stateful firewall at instance level:

**Security Group ID**: sg-09e16ad00dfd00582

**Inbound Rules**:
```
Port 22 (SSH):   41.85.163.81/32  - Restricted to administrator IP only
Port 80 (HTTP):  0.0.0.0/0        - Public web access
```

**Outbound Rules**:
```
Port 443 (HTTPS): 0.0.0.0/0  - Software updates, API calls
Port 80 (HTTP):   0.0.0.0/0  - Package downloads
Port 53 (DNS):    0.0.0.0/0  - Name resolution
```

**Security Principle**: Default deny - only explicitly allowed traffic permitted

### 2. Compute Security

#### EC2 Instance
- **Instance ID**: i-000e170aaa531df35
- **Type**: t3.micro (free tier eligible)
- **AMI**: ami-0f00d706c4a80fd93 (Amazon Linux 2023)
- **Public IP**: 13.222.96.187
- **Private IP**: 10.0.1.235

#### Instance Hardening
1. **IMDSv2 Enforcement**
   ```hcl
   metadata_options {
     http_endpoint = "enabled"
     http_tokens   = "required"
     http_put_response_hop_limit = 1
   }
   ```
   - Prevents SSRF attacks
   - Requires session tokens for metadata access
   - Protects AWS credentials stored in instance metadata

2. **EBS Encryption**
   ```hcl
   root_block_device {
     encrypted   = true
     volume_type = "gp3"
     volume_size = 8
   }
   ```
   - All data at rest is encrypted
   - AWS-managed encryption keys
   - Meets compliance requirements

3. **Monitoring**
   - Detailed CloudWatch monitoring enabled
   - EBS optimization enabled
   - Real-time performance metrics

### 3. Identity and Access Management (IAM)

#### IAM Role: iac-demo-ec2-role
**ARN**: arn:aws:iam::473550160619:role/iac-demo-ec2-role

**Trust Policy**:
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    }
  }]
}
```
Only EC2 service can assume this role.

#### Permissions (Least Privilege)

**1. CloudWatch Logs Access**
```json
{
  "Effect": "Allow",
  "Action": [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "logs:DescribeLogStreams"
  ],
  "Resource": "arn:aws:logs:*:*:*"
}
```
- Allows application logging to CloudWatch
- No delete or modify permissions
- Audit trail of all log operations

**2. S3 Read-Only Access**
```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:GetBucketLocation"
  ],
  "Resource": [
    "arn:aws:s3:::iac-demo-leelee222-local-5722280d",
    "arn:aws:s3:::iac-demo-leelee222-local-5722280d/*"
  ]
}
```
- Read-only access to specific bucket
- No write or delete permissions
- Scoped to single bucket only

#### Instance Profile
Attaches IAM role to EC2 instance without storing credentials on the instance.

### 4. Storage Security

#### S3 Bucket: iac-demo-leelee222-local-5722280d

**Security Controls**:

1. **Public Access Block**
   ```hcl
   block_public_acls       = true
   block_public_policy     = true
   ignore_public_acls      = true
   restrict_public_buckets = true
   ```
   - Prevents accidental public exposure
   - Blocks all public access methods

2. **Versioning Enabled**
   ```hcl
   versioning {
     enabled = true
   }
   ```
   - Protects against accidental deletion
   - Maintains file history
   - Enables recovery from ransomware

3. **Server-Side Encryption**
   ```hcl
   server_side_encryption_configuration {
     rule {
       apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
       }
     }
   }
   ```
   - All objects encrypted at rest
   - Automatic encryption on upload
   - AES-256 encryption standard

### 5. Logging and Monitoring

#### VPC Flow Logs
**Log Group**: /aws/vpc/local-flow-logs

**Purpose**: Network traffic analysis and security monitoring

**Captures**:
- Source and destination IP addresses
- Source and destination ports
- Protocol (TCP/UDP/ICMP)
- Packet and byte counts
- Action (ACCEPT/REJECT)

**Use Cases**:
- Detect unusual traffic patterns
- Investigate security incidents
- Troubleshoot connectivity issues
- Compliance and audit requirements

#### CloudWatch Logs
- Centralized log storage
- Application and system logs
- 7-day retention (configurable)
- Integration with CloudWatch Insights for log analysis

### 6. Infrastructure as Code Security

#### Automated Security Scanning
**Tool**: Checkov v3.2.490

**Scan Results**:
- Total checks: 57
- Passed: 50 (87.7%)
- Failed: 7 (acceptable for learning environment)

**Key Security Checks**:
- IMDSv2 enforcement
- Encryption at rest
- Public access blocking
- Security group restrictions
- IAM policy validation

#### CI/CD Security Pipeline
**Platform**: GitHub Actions

**Automated Checks**:
1. Terraform validation
2. Security scanning on every push
3. Policy enforcement on pull requests
4. Pipeline blocking on critical failures

**Workflow File**: `.github/workflows/terraform-security.yml`

### 7. Security Best Practices Implemented

#### Defense in Depth
Multiple security layers:
1. Network ACLs (subnet level)
2. Security Groups (instance level)
3. IAM policies (identity level)
4. Encryption (data level)
5. Monitoring (detection level)

#### Principle of Least Privilege
- IAM roles with minimal required permissions
- Security groups allow only necessary ports
- SSH restricted to single trusted IP
- S3 read-only access

#### Secure by Default
- Encryption enabled by default
- Public access blocked by default
- IMDSv2 required by default
- Egress traffic restricted to essential services

#### Auditability
- VPC Flow Logs capture all network traffic
- CloudWatch logs for application events
- Terraform state tracks all infrastructure changes
- Version control for IaC code

## Security Incident Response

### Monitoring Alerts
Configure CloudWatch alarms for:
- Unusual network traffic patterns
- Multiple SSH authentication failures
- Unexpected IAM role usage
- S3 access from unknown IPs

### Incident Investigation
1. Check VPC Flow Logs for suspicious traffic
2. Review CloudWatch Logs for application anomalies
3. Audit IAM CloudTrail for unauthorized API calls
4. Analyze security group changes

### Emergency Response
```bash
terraform apply -var="allowed_ssh_cidr=['0.0.0.0/0']"
```
Temporarily allow access from anywhere (emergency only).

## Compliance Considerations

### Standards Alignment
- **CIS AWS Foundations Benchmark**: Network isolation, encryption, monitoring
- **NIST Cybersecurity Framework**: Identify, Protect, Detect controls
- **SOC 2**: Logging, access controls, change management

### Audit Trail
- All infrastructure changes versioned in Git
- Terraform state tracks resource modifications
- VPC Flow Logs provide network audit trail
- CloudWatch Logs for application activities

## Cost Management

### Monthly Cost Breakdown
| Resource | Cost |
|----------|------|
| NAT Gateway | ~$32/month |
| EC2 t3.micro | $0 (free tier) |
| VPC & Networking | $0 (free tier) |
| CloudWatch Logs | $0 (within free tier) |
| S3 Storage | $0 (within free tier) |
| **Total** | **~$33/month** |

### Cost Optimization Tips
1. **Remove NAT Gateway** if private subnet not needed (-$32/month)
2. Use VPC Endpoints for AWS services (free)
3. Set CloudWatch log retention to 7 days
4. Use S3 lifecycle policies for old data

## Security Hardening Checklist

### Current Implementation
- [x] VPC with isolated subnets
- [x] Security groups with minimal ports
- [x] Network ACLs configured
- [x] SSH restricted to trusted IP
- [x] IMDSv2 enforced
- [x] EBS encryption enabled
- [x] S3 public access blocked
- [x] S3 versioning enabled
- [x] S3 encryption at rest
- [x] IAM least privilege
- [x] VPC Flow Logs enabled
- [x] CloudWatch monitoring
- [x] Automated security scanning

### Future Enhancements
- [ ] AWS WAF for web application firewall
- [ ] GuardDuty for threat detection
- [ ] AWS Config for compliance monitoring
- [ ] KMS customer-managed keys
- [ ] Multi-factor authentication for SSH
- [ ] Bastion host for private subnet access
- [ ] AWS Systems Manager Session Manager
- [ ] Automated backup policies
- [ ] DDoS protection with Shield
- [ ] Certificate management with ACM

## Terraform Security Variables

### Required Variables
```hcl
variable "allowed_ssh_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH"
  default     = ["41.85.163.81/32"]
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "aws_region" {
  type        = string
  description = "AWS deployment region"
  default     = "us-east-1"
}
```

### Get Your IP
```bash
curl ifconfig.me
```

## Security Testing

### Manual Tests
1. **SSH Access Test**
   ```bash
   ssh -i your-key.pem ec2-user@13.222.96.187
   ```

2. **IMDSv2 Test**
   ```bash
   # Should fail (IMDSv1):
   curl http://169.254.169.254/latest/meta-data/
   
   # Should succeed (IMDSv2):
   TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
   curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
   ```

3. **S3 Access Test**
   ```bash
   aws s3 ls s3://iac-demo-leelee222-local-5722280d
   ```

4. **VPC Flow Logs Test**
   ```bash
   aws logs tail /aws/vpc/local-flow-logs --region us-east-1 --follow
   ```

### Automated Tests
```bash
checkov -d . --quiet
```

## Additional Resources

- [VPC-EXPLAINED.md](VPC-EXPLAINED.md) - Deep dive into VPC networking
- [IaC-security-workflow.md](IaC-security-workflow.md) - Security implementation details
- [CI-CD-SECURITY.md](CI-CD-SECURITY.md) - Pipeline security automation
- [JUNIOR-DEVSECOPS-GUIDE.md](JUNIOR-DEVSECOPS-GUIDE.md) - Beginner-friendly guide
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services)

## Contact and Support

**Repository**: https://github.com/leelee222/iac-demo  
**Documentation**: All security documentation in repository  
**Issues**: Report security issues via GitHub Issues

---

**Last Updated**: November 2025  
**Review Cycle**: Monthly security audits recommended
