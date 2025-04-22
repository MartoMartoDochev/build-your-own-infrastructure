resource "aws_vpc" "byoi_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "byoi-vpc"
  }
}

