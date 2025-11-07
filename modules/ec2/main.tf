resource "aws_instance" "vm" {
  ami                    = "ami-12345678"
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = var.instance_name
  }
}
