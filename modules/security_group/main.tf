resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = "Security group with restricted access for SSH and HTTP"
  vpc_id      = var.vpc_id  # Attach to VPC for network isolation

  # SSH restricted to specific CIDR ranges (configure via variable)
  ingress {
    description = "SSH access from trusted networks only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # HTTP open for public web traffic
  ingress {
    description = "HTTP access for web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Restricted egress: only HTTP, HTTPS, and DNS
  egress {
    description = "HTTPS outbound traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "DNS outbound traffic"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}
