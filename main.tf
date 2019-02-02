#provider
provider "aws" {
   region = "us-east-1"
}

#vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "tf-jenkins-vpc"
  }
}

# subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "192.168.10.0/24"
  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = "true"

  tags = {
    Name = "tf-jenkins-subnet"
  }
}


# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "TF VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "TF Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.my_subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}






