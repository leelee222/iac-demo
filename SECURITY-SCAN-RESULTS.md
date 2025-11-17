# Security Scan Results - Week 6

## Initial Scan Summary

**Date**: November 10, 2025  
**Tool**: Checkov v3.2.490  
**Framework**: Terraform

### Results:
- Passed: 6 checks
- Failed: 8 checks
- Total: 14 checks

---

## Failed Security Checks

### EC2 Instance Issues (4 issues)

#### 1. CKV_AWS_126: EC2 Detailed Monitoring Not Enabled
**Severity**: Medium  
**File**: `modules/ec2/main.tf`  
**Issue**: Instance doesn't have detailed monitoring enabled  
**Fix**: Add `monitoring = true`

#### 2. CKV_AWS_135: EC2 Not EBS Optimized
**Severity**: Low  
**File**: `modules/ec2/main.tf`  
**Issue**: Instance is not EBS optimized for better performance  
**Fix**: Add `ebs_optimized = true`

#### 3. CKV_AWS_8: EBS Encryption Not Enabled
**Severity**: HIGH  
**File**: `modules/ec2/main.tf`  
**Issue**: Root volume not encrypted  
**Fix**: Add root_block_device with encryption enabled

#### 4. CKV_AWS_79: IMDSv1 Enabled (Metadata Service)
**Severity**: HIGH  
**File**: `modules/ec2/main.tf`  
**Issue**: Instance Metadata Service v1 is enabled (security risk)  
**Fix**: Enforce IMDSv2 in metadata_options

---

### Security Group Issues (4 issues)

#### 5. CKV_AWS_24: SSH Open to Internet (0.0.0.0/0)
**Severity**: CRITICAL  
**File**: `modules/security_group/main.tf`  
**Issue**: Port 22 (SSH) accessible from anywhere  
**Fix**: Restrict to specific IP ranges

#### 6. CKV_AWS_260: HTTP Open to Internet (0.0.0.0/0)
**Severity**: HIGH  
**File**: `modules/security_group/main.tf`  
**Issue**: Port 80 (HTTP) accessible from anywhere  
**Fix**: Consider restricting or acceptable for web servers

#### 7. CKV_AWS_382: Unrestricted Egress
**Severity**: Medium  
**File**: `modules/security_group/main.tf`  
**Issue**: All outbound traffic allowed  
**Fix**: Restrict egress to specific ports/destinations

#### 8. CKV_AWS_23: Security Group Rules Missing Descriptions
**Severity**: Low  
**File**: `modules/security_group/main.tf`  
**Issue**: Ingress/egress rules don't have descriptions  
**Fix**: Add description field to each rule

---

## Passed Security Checks

1. No hard-coded secrets in EC2 user data
2. EC2 instance doesn't have public IP
3. S3 bucket policy doesn't lockout all but root user
4. No security group allows all traffic on all ports
5. No security group allows ingress to RDP port 3389
6. No hard-coded AWS credentials in provider

---

## Priority Fix Order

### Critical Priority
1. SSH open to internet (CKV_AWS_24)
2. IMDSv1 enabled (CKV_AWS_79)
3. EBS not encrypted (CKV_AWS_8)

### High Priority
4. HTTP open to internet (CKV_AWS_260)
5. Unrestricted egress (CKV_AWS_382)

### Medium/Low Priority
6. Detailed monitoring (CKV_AWS_126)
7. EBS optimization (CKV_AWS_135)
8. Missing descriptions (CKV_AWS_23)

---

## Next Steps

1. Install Checkov - COMPLETE
2. Run security scans - COMPLETE
3. Fix detected misconfigurations
4. Re-run scan to verify fixes
5. Document security improvements

---

## Resources

- [Checkov Policy Reference](https://docs.prismacloud.io/en/enterprise-edition/policy-reference)
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)
- [Terraform AWS Provider Security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
