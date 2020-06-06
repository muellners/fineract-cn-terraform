resource "aws_internet_gateway" "akounts-internet-gw" {
  vpc_id = aws_vpc.akounts-vpc.id

  tags  = {
    Name = "akounts-internet-gw"
  }
}

resource "aws_route_table" "akounts-rt" {
  vpc_id = aws_vpc.akounts-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.akounts-internet-gw.id
  }

  tags  = {
    Name = "akounts-rt"
  }
}

resource "aws_route_table_association" "akounts-public-1" {
  route_table_id = aws_route_table.akounts-rt.id
  subnet_id = aws_subnet.akounts-public-1.id
}

resource "aws_route_table_association" "akounts-public-2" {
  route_table_id = aws_route_table.akounts-rt.id
  subnet_id = aws_subnet.akounts-public-2.id
}
