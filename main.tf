terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


module "network_module" {
  source = "./network"
  cidr_block_public              = "10.0.0.0/24"
  cidr_block_private             = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
}

module "security_group" {
  source = "./security_group"
  aws_vpc_id = module.network_module.aws_vpc_output
}

module "ec2" {
  source = "./ec2"
  aws_public_subnet = module.network_module.aws_public_subnet_output
  aws_private_subnet = module.network_module.aws_private_subnet_output
  aws_security_group_public_instance = module.security_group.aws_security_group_public_instance_output
  aws_security_group_private_instance = module.security_group.aws_security_group_private_instance_output
  ami                    = "ami-0e5182fad1edfaa68"
  instance_type          = "t2.micro"
}

