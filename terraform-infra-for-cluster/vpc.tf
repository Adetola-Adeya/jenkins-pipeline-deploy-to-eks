resource "aws_vpc" "oneapp-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "oneapp-vpc"
  }
}
