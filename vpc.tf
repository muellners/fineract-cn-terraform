resource "aws_vpc" "akounts-vpc" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "akounts"
  }
}

resource "aws_subnet" "akounts-public-1" {
  vpc_id = aws_vpc.akounts-vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags  = {
    Name: "akounts-public-1"
  }
}

resource "aws_subnet" "akounts-public-2" {
  vpc_id = aws_vpc.akounts-vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name: "akounts-public-2"
  }
}
