
// Define main vpc
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

// Define internet gateway to make vpc can access to internet
resource "aws_internet_gateway" "terraform_internet_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
}

// Public subnet, contain 1 bashtion ec2 instance and Nat gateway 
resource "aws_subnet" "terraform_public_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.cidr_block_public
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

// private subnet, contain 1 ec2 instance
resource "aws_subnet" "terraform_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.cidr_block_private
  availability_zone = var.availability_zone
}

// Elastic ip
resource "aws_eip" "terraform_eip" {
  vpc  = true
}

// nat gateway: make private subnet can access to the internet, put inside public subnet
resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.terraform_eip.id
  subnet_id     = aws_subnet.terraform_public_subnet.id

  //depends_on = [aws_internet_gateway.terraform_internet_gateway]
}

// Route table for public subnet
resource "aws_route_table" "terraform_route_table_public_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  route = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_internet_gateway.id
    egress_only_gateway_id    = ""
    instance_id               = ""
    ipv6_cidr_block           = ""
    nat_gateway_id            = ""
    network_interface_id      = ""
    transit_gateway_id        = ""
    carrier_gateway_id = ""
    destination_prefix_list_id = ""
    vpc_peering_connection_id = ""
    vpc_endpoint_id = ""
    local_gateway_id = ""
  }]
}

// Route table for private subnet
resource "aws_route_table" "terraform_route_table_private_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  route = [{
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_nat_gateway.id
    egress_only_gateway_id    = ""
    instance_id               = ""
    ipv6_cidr_block           = ""
    network_interface_id      = ""
    transit_gateway_id        = ""
    carrier_gateway_id = ""
    destination_prefix_list_id = ""
    vpc_peering_connection_id = ""
    vpc_endpoint_id = ""
    local_gateway_id = ""
    gateway_id = ""
  }]
}

// route table association for public subnet
resource "aws_route_table_association" "terraform_public_route_table_association" {
  subnet_id = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_route_table_public_subnet.id
}

// route table association for private subnet
resource "aws_route_table_association" "terraform_private_route_table_association" {
  subnet_id = aws_subnet.terraform_private_subnet.id
  route_table_id = aws_route_table.terraform_route_table_private_subnet.id
}

output "aws_vpc_output" {
  value = aws_vpc.terraform_vpc.id
}

output "aws_public_subnet_output" {
  value = aws_subnet.terraform_public_subnet
}

output "aws_private_subnet_output" {
  value = aws_subnet.terraform_private_subnet
}

