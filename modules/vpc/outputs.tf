output "vpc_id" {
  value = aws_vpc.byoi_vpc.id
}

output "cidr_block" {
  value = aws_vpc.byoi_vpc.cidr_block
}

