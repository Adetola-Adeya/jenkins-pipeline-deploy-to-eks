resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.oneapp-vpc.id

  tags = {
    Name = "igw"
  }
}