// ec2 key pair

resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_key_tutorial"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAhvkbwoQflj9D2wIgLlMN/Fu5SKhadE1UB5TjXFKRFmXd3YyHbgloYg2IaG3uEogrSz2wO8bDdA35KDxuaRFcQ/YNOmJ+LGfEGSVdBlkt/AWDhimOc0wOUGl6Z7/JAAiRe1fOstpALUwRELEzVtqBp2KyEJ8LDk9jZQgRJVw0MYNrkT7x7DGJzvI6vT3i42yc3g2XCq1v7InJbHWhOS9iLbEbxjRN7ca5xLFTy2wS8Uzl7O4Iste+ogOUlK2FOCJqBNFWlrw7yZ2TrvTh7EEhhaYZVLXxWwLDvMWkwYnDQZ7ngpu9iwun4h/3+BMx1JZh5uxPT8k1HV7qpIxdeIF/"
}

// ec2 for public subnet
resource "aws_instance" "terraform_instance_public" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.aws_public_subnet.id
  key_name               = aws_key_pair.terraform_key_pair.id
  vpc_security_group_ids = [var.aws_security_group_public_instance.id]
}
// ec2 for private subnet
resource "aws_instance" "terraform_instance_private" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.aws_private_subnet.id
  key_name               = aws_key_pair.terraform_key_pair.id
  vpc_security_group_ids = [var.aws_security_group_private_instance.id]
}