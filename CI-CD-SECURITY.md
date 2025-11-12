# CI/CD Security Workflow Documentation

## Overview

This project implements automated security scanning in the CI/CD pipeline using GitHub Actions and Checkov.

---

## 🔄 Workflows

### 1. **IaC Security Scan** (`security-scan.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual trigger via workflow_dispatch

**Jobs:**

#### a) Terraform Security Scan
- ✅ Checks Terraform formatting
- ✅ Validates Terraform configuration
- ✅ Runs Checkov security scan
- ❌ **Fails pipeline if security issues found**
- 📤 Uploads scan results as artifacts

#### b) Terraform Plan
- 📋 Runs `terraform plan` to preview changes
- ⏸️ Only runs if security scan passes

#### c) Pipeline Summary
- 📊 Reports overall pipeline status
- ❌ Blocks deployment if security issues exist

---

### 2. **Test Security Pipeline Blocking** (`test-blocking.yml`)

**Purpose:** Verify that the pipeline correctly blocks insecure code

**Triggers:**
- Manual only (workflow_dispatch)

**Process:**
1. Creates intentionally insecure Terraform code
2. Runs Checkov security scan
3. Verifies that pipeline fails
4. Cleans up test files

**Insecure Test Cases:**
- SSH open to 0.0.0.0/0
- All ports open to internet
- Unencrypted S3 bucket
- EC2 without encryption/monitoring

---

## 🛡️ Security Checks

### Checkov Policies Enforced

**Critical:**
- ✅ No SSH open to 0.0.0.0/0 (port 22)
- ✅ EBS volumes must be encrypted
- ✅ IMDSv2 required for EC2
- ✅ No all-port ingress rules

**High:**
- ✅ Detailed monitoring enabled
- ✅ EBS optimization enabled
- ✅ Restricted egress traffic
- ✅ Security group rules have descriptions

**Exceptions:**
- ⚠️ HTTP port 80 open to 0.0.0.0/0 (acceptable for web servers)

---

## 🚀 Usage

### Run Security Scan Locally

```bash
# Install Checkov
pip install checkov

# Run scan
checkov -d . --framework terraform

# Skip specific checks
checkov -d . --framework terraform --skip-check CKV_AWS_260
```

### Trigger GitHub Actions

**Automatic Triggers:**
```bash
# Push to main branch
git push origin main

# Create pull request
git checkout -b feature-branch
git push origin feature-branch
# Create PR on GitHub
```

**Manual Trigger:**
1. Go to GitHub Actions tab
2. Select "IaC Security Scan" workflow
3. Click "Run workflow"

### Test Pipeline Blocking

```bash
# Via GitHub UI:
# 1. Go to Actions tab
# 2. Select "Test Security Pipeline Blocking"
# 3. Click "Run workflow"
# 4. Check that it correctly fails on insecure code
```

---

## 📊 Pipeline Behavior

### ✅ When Code is Secure

```
1. Security Scan → PASS ✅
2. Terraform Plan → RUNS 📋
3. Summary → SUCCESS ✅
4. Deployment → ALLOWED 🚀
```

### ❌ When Security Issues Found

```
1. Security Scan → FAIL ❌
2. Terraform Plan → SKIPPED ⏭️
3. Summary → FAILURE ❌
4. Deployment → BLOCKED 🚫
```

---

## 🔧 Configuration

### Customize Security Checks

Edit `.github/workflows/security-scan.yml`:

```yaml
- name: Run Checkov Security Scan
  uses: bridgecrewio/checkov-action@v12
  with:
    directory: .
    framework: terraform
    soft_fail: false              # Change to true to allow warnings
    skip_check: CKV_AWS_260       # Add more checks to skip
```

### Add More Frameworks

```yaml
- name: Run Checkov on Docker
  uses: bridgecrewio/checkov-action@v12
  with:
    directory: .
    framework: dockerfile
```

---

## 📈 Monitoring & Reporting

### View Scan Results

1. **GitHub Actions UI:**
   - Go to Actions tab
   - Click on workflow run
   - View "Checkov Security Scan" step

2. **Download Artifacts:**
   - Scroll to bottom of workflow run
   - Download "checkov-results" artifact

3. **Pull Request Comments:**
   - Checkov automatically comments on PRs with findings

---

## 🐛 Troubleshooting

### Pipeline Always Fails

**Check:**
1. Are there legitimate security issues?
   ```bash
   checkov -d . --framework terraform
   ```
2. Do you need to skip certain checks?
   ```yaml
   skip_check: CKV_AWS_260,CKV_AWS_123
   ```

### Pipeline Always Passes

**Check:**
1. Is `soft_fail` set to `true`? (should be `false`)
2. Are test files excluded?
3. Run locally to verify issues exist

### Authentication Issues

**For AWS resources:**
- GitHub Actions uses dummy credentials for validation
- Real deployment requires AWS credentials as secrets

---

## 🎯 Best Practices

1. **Always run security scans before merging**
   - Set up branch protection rules
   - Require status checks to pass

2. **Review security exceptions carefully**
   - Document why checks are skipped
   - Get team approval for exceptions

3. **Keep Checkov updated**
   - Update version in workflow regularly
   - Review new policies

4. **Test the pipeline**
   - Run blocking test regularly
   - Verify failures are caught

5. **Monitor scan results**
   - Review failed runs
   - Track trends over time

---

## 📚 Additional Resources

- [Checkov Documentation](https://www.checkov.io/documentation.html)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Bridgecrew Checkov Action](https://github.com/bridgecrewio/checkov-action)
- [Terraform Security Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

---

## 🔄 Workflow Files

- `.github/workflows/security-scan.yml` - Main security pipeline
- `.github/workflows/test-blocking.yml` - Test pipeline blocking

---

## ✅ Success Criteria

Your CI/CD security pipeline is working correctly when:

1. ✅ Security scans run on every push/PR
2. ✅ Pipeline fails when insecure code is detected
3. ✅ Terraform plan only runs after security scan passes
4. ✅ Test blocking workflow verifies failures work
5. ✅ Scan results are uploaded as artifacts
6. ✅ Team can see security status in GitHub UI
