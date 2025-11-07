#!/bin/bash
# Infrastructure Testing Script for IaC Demo
# This script validates that all Terraform modules are working correctly

echo "🧪 Starting Infrastructure Tests..."
echo "=================================="

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo ""
echo "📋 Test 1: Terraform Configuration Validation"
echo "----------------------------------------------"
terraform validate > /dev/null 2>&1
test_result $? "Terraform configuration is valid"

echo ""
echo "📋 Test 2: Check Required Files"
echo "----------------------------------------------"
[ -f "main.tf" ]
test_result $? "main.tf exists"

[ -f "variables.tf" ]
test_result $? "variables.tf exists"

[ -f "outputs.tf" ]
test_result $? "outputs.tf exists"

[ -f "provider.tf" ]
test_result $? "provider.tf exists"

echo ""
echo "📋 Test 3: Check Module Structure"
echo "----------------------------------------------"
[ -d "modules/s3_bucket" ]
test_result $? "S3 bucket module exists"

[ -d "modules/ec2" ]
test_result $? "EC2 module exists"

[ -d "modules/security_group" ]
test_result $? "Security group module exists"

[ -f "modules/s3_bucket/main.tf" ] && [ -f "modules/s3_bucket/variables.tf" ] && [ -f "modules/s3_bucket/outputs.tf" ]
test_result $? "S3 bucket module has all required files"

[ -f "modules/ec2/main.tf" ] && [ -f "modules/ec2/variables.tf" ] && [ -f "modules/ec2/outputs.tf" ]
test_result $? "EC2 module has all required files"

[ -f "modules/security_group/main.tf" ] && [ -f "modules/security_group/variables.tf" ] && [ -f "modules/security_group/outputs.tf" ]
test_result $? "Security group module has all required files"

echo ""
echo "📋 Test 4: Verify Infrastructure State"
echo "----------------------------------------------"
terraform show > /dev/null 2>&1
test_result $? "Terraform state is readable"

# Check if resources exist in state
BUCKET_EXISTS=$(terraform state list 2>/dev/null | grep -c "module.s3_bucket.aws_s3_bucket.bucket" || true)
test_result $([ $BUCKET_EXISTS -eq 1 ] && echo 0 || echo 1) "S3 bucket exists in state"

INSTANCE_EXISTS=$(terraform state list 2>/dev/null | grep -c "module.ec2_instance.aws_instance.vm" || true)
test_result $([ $INSTANCE_EXISTS -eq 1 ] && echo 0 || echo 1) "EC2 instance exists in state"

SG_EXISTS=$(terraform state list 2>/dev/null | grep -c "module.security_group.aws_security_group.sg" || true)
test_result $([ $SG_EXISTS -eq 1 ] && echo 0 || echo 1) "Security group exists in state"

echo ""
echo "📋 Test 5: Verify Outputs"
echo "----------------------------------------------"
BUCKET_OUTPUT=$(terraform output -raw bucket_name 2>/dev/null)
test_result $([ ! -z "$BUCKET_OUTPUT" ] && echo 0 || echo 1) "Bucket name output is set"

INSTANCE_OUTPUT=$(terraform output -raw instance_id 2>/dev/null)
test_result $([ ! -z "$INSTANCE_OUTPUT" ] && echo 0 || echo 1) "Instance ID output is set"

SG_OUTPUT=$(terraform output -raw security_group_id 2>/dev/null)
test_result $([ ! -z "$SG_OUTPUT" ] && echo 0 || echo 1) "Security group ID output is set"

echo ""
echo "📋 Test 6: Variables Configuration"
echo "----------------------------------------------"
grep -q "variable \"aws_region\"" variables.tf
test_result $? "aws_region variable is defined"

grep -q "variable \"instance_type\"" variables.tf
test_result $? "instance_type variable is defined"

grep -q "variable \"bucket_prefix\"" variables.tf
test_result $? "bucket_prefix variable is defined"

echo ""
echo "📋 Test 7: Module Dependencies"
echo "----------------------------------------------"
# Check if EC2 module uses security group from security_group module
grep -q "module.security_group.sg_id" main.tf
test_result $? "EC2 module depends on security_group module"

echo ""
echo "=================================="
echo "📊 Test Summary"
echo "=================================="
echo -e "${GREEN}✅ Passed: $TESTS_PASSED${NC}"
echo -e "${RED}❌ Failed: $TESTS_FAILED${NC}"
echo "Total Tests: $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All tests passed! Your infrastructure is correctly configured.${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}⚠️  Some tests failed. Please review the errors above.${NC}"
    exit 1
fi
