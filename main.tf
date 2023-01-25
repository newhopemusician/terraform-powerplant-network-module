resource "aws_vpc" "Main" {                # Creating VPC here
  cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
   vpc_id =  aws_vpc.Main.id               # vpc_id will be generated after we create VPC
}

resource "aws_subnet" "publicsubnet" {    # Creating Public Subnets
  vpc_id =  aws_vpc.Main.id
  cidr_block = "${var.public_subnets}"        # CIDR block of public subnets
}

resource "aws_route_table" "defaultroute" {    # Creating RT for Public Subnet
   vpc_id =  aws_vpc.Main.id
   route {
      cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
      gateway_id = aws_internet_gateway.IGW.id
   }
}

resource "aws_route_table_association" "routeassoc" {
   subnet_id = aws_subnet.publicsubnet.id
   route_table_id = aws_route_table.defaultroute.id
}

resource "aws_eip" "nateIP" {
  vpc   = true
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.Main.id

  ingress {
    description      = "Allows all Traffic inbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}
