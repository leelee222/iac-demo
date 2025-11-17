resource "aws_instance" "vm" {
  ami                    = "ami-12345678"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id  # Deploy in specific subnet
  vpc_security_group_ids = [var.sg_id]
  
  iam_instance_profile = var.iam_instance_profile
  
  monitoring    = true
  ebs_optimized = true

  # Enforce IMDSv2 for enhanced security (prevents SSRF attacks)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Encrypt root volume for data protection
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 8
  }

  tags = {
    Name = var.instance_name
  }
}
