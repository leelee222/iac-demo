# Testing Guide - IaC Demo

This document outlines how to test and validate your Terraform infrastructure.

## 🧪 Quick Test

Run the automated test script:
```bash
bash test-infrastructure.sh
```

This will run **22 automated tests** covering:
- Configuration validation
- File structure
- Module organization
- State verification
- Output validation
- Variable definitions
- Module dependencies

---

## 🔍 Manual Testing Steps

### 1. **Validate Configuration**
Ensures syntax and configuration are correct:
```bash
terraform validate
```
✅ **Expected**: "Success! The configuration is valid."

---

### 2. **Format Check**
Checks if code follows Terraform formatting standards:
```bash
terraform fmt -check
```
To auto-format:
```bash
terraform fmt -recursive
```

---

### 3. **Plan Review**
Preview what Terraform will do:
```bash
terraform plan
```
✅ **Expected**: Should show:
- 3 resources to add (EC2, S3, Security Group)
- Clear module structure
- No errors

---

### 4. **Apply Infrastructure**
Create the infrastructure:
```bash
terraform apply
```
✅ **Expected**: 
- "Apply complete! Resources: 3 added, 0 changed, 0 destroyed"
- Outputs displayed

---

### 5. **Verify Outputs**
Check that outputs are correctly set:
```bash
terraform output
```
✅ **Expected outputs**:
- `bucket_name`: S3 bucket name
- `instance_id`: EC2 instance ID
- `security_group_id`: Security group ID

Get specific output:
```bash
terraform output bucket_name
terraform output instance_id
terraform output security_group_id
```

---

### 6. **Check State**
List all managed resources:
```bash
terraform state list
```
✅ **Expected resources**:
```
module.ec2_instance.aws_instance.vm
module.s3_bucket.aws_s3_bucket.bucket
module.s3_bucket.random_id.bucket_id
module.security_group.aws_security_group.sg
```

Get details of a specific resource:
```bash
terraform state show module.ec2_instance.aws_instance.vm
terraform state show module.s3_bucket.aws_s3_bucket.bucket
terraform state show module.security_group.aws_security_group.sg
```

---

### 7. **Module Testing**
Test each module independently:

```bash
# View module outputs
terraform output -json

# Check module dependencies (security_group → ec2)
terraform graph | dot -Tpng > graph.png  # Requires graphviz
```

---

### 8. **Variable Testing**
Test with different variable values:

Create `terraform.tfvars`:
```hcl
aws_region     = "us-west-2"
instance_type  = "t2.small"
bucket_prefix  = "my-custom-prefix"
```

Then apply:
```bash
terraform plan
```

---

### 9. **Destroy Test**
Verify clean destruction:
```bash
terraform destroy
```
✅ **Expected**: "Destroy complete! Resources: 3 destroyed."

Then verify state is empty:
```bash
terraform state list
```
✅ **Expected**: No output (empty state)

---

### 10. **Re-apply Test**
Test idempotency (should create same resources):
```bash
terraform apply
terraform plan
```
✅ **Expected on second plan**: "No changes. Your infrastructure matches the configuration."

---

## 🔧 LocalStack Testing

If using LocalStack, verify it's running:

```bash
# Check LocalStack status
localstack status

# Check if LocalStack is accessible
curl http://localhost:4566/_localstack/health
```

Test LocalStack resources:
```bash
# List S3 buckets
aws --endpoint-url=http://localhost:4566 s3 ls

# List EC2 instances
aws --endpoint-url=http://localhost:4566 ec2 describe-instances

# List security groups
aws --endpoint-url=http://localhost:4566 ec2 describe-security-groups
```

---

## ✅ Success Criteria

Your infrastructure is correctly configured if:

1. ✅ **All 22 automated tests pass**
2. ✅ **terraform validate** succeeds
3. ✅ **terraform plan** shows 3 resources
4. ✅ **terraform apply** creates resources without errors
5. ✅ **All 3 outputs** are populated
6. ✅ **terraform state list** shows 4 resources (3 main + 1 random_id)
7. ✅ **Module dependencies** work (EC2 uses SG from security_group module)
8. ✅ **terraform destroy** removes all resources
9. ✅ **Re-applying** creates identical infrastructure

---

## 🐛 Troubleshooting

### Error: Module not installed
**Solution**:
```bash
terraform init
```

### Error: Connection refused (LocalStack)
**Solution**:
```bash
localstack start -d
```

### Error: Duplicate provider
**Solution**: Check that provider is only defined once in `provider.tf`

### Error: Invalid resource reference
**Solution**: Check that outputs reference module outputs, not direct resources

---

## 📊 Test Results Expected

When you run `bash test-infrastructure.sh`, you should see:

```
✅ Passed: 22
❌ Failed: 0
Total Tests: 22

🎉 All tests passed! Your infrastructure is correctly configured.
```

---

## 🎯 Advanced Testing

### Terraform Graph
Visualize dependencies:
```bash
terraform graph > graph.dot
```

### Terraform Console
Interactive testing:
```bash
terraform console
> module.s3_bucket.bucket_name
> var.instance_type
```

### Provider Testing
```bash
terraform providers
```

---

## 📝 Testing Checklist

Before committing code:
- [ ] Run `bash test-infrastructure.sh` - all tests pass
- [ ] Run `terraform fmt -recursive` - code is formatted
- [ ] Run `terraform validate` - configuration is valid
- [ ] Run `terraform plan` - no unexpected changes
- [ ] All outputs are populated
- [ ] State file is in `.gitignore`
- [ ] LocalStack is running (for local testing)
- [ ] Documentation is up to date
