resource "aws_eip" "nat_eip" {
  count = var.az_count
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count         = var.az_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  tags = {
    Name = "nat-${count.index}"
  }
}