// security group for ec2 public
resource "aws_security_group" "terraform_security_group_public_ec2" {
  vpc_id = var.aws_vpc_id
  ingress = [{
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks : null
    prefix_list_ids : null
    security_groups : null
    self : null,
    description : null
  }]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
// security group for ec2 private
resource "aws_security_group" "terraform_security_group_private_ec2" {
  vpc_id = var.aws_vpc_id

  ingress = [{
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks : null
    prefix_list_ids : null
    security_groups : null
    self : null,
    description : null
    },
    {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "icmp"
      ipv6_cidr_blocks : null
      prefix_list_ids : null
      security_groups : null
      self : null,
      description : null
  }]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "aws_security_group_public_instance_output" {
  value = aws_security_group.terraform_security_group_public_ec2
}

output "aws_security_group_private_instance_output" {
  value = aws_security_group.terraform_security_group_private_ec2
}