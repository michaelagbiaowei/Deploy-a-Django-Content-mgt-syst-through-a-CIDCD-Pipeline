# VPC = allows you to secure your virtual networking environment,
#       includes your IP addresses, subnets and network gateways. 

resource "aws_vpc" "Bond_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "Bond_vpc"
      }
}

# Internet Gateway a horizontally scaled, redundant,and highly available VPC component 
# that allows communication between your VPC and the internet

  resource "aws_internet_gateway" "Bond_internet_gateway" {
    vpc_id = aws_vpc.Bond_vpc.id
    tags ={
        Name = "Bond_internet_gateway"
    }
  }


  # Public Route Table = route table contains a set of rules (also known as routes) 
  # that are used to determine where network traffic is directed. 

  resource "aws_route_table" "Bond-route-table-public" {
    vpc_id = aws_vpc.Bond_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Bond_internet_gateway.id
    }

    tags = {
        Name = "Bond-route-table-public"
    }
  }

#  Public subnet 1 with public route table = a subnet that's associated with a route table
#  that has a route to an internet gateway

resource "aws_route_table_association" "Bond-public-subnet1-association" {
    subnet_id      = aws_subnet.Bond-public-subnet1.id
    route_table_id = aws_route_table.Bond-route-table-public.id
}


# Public subnet 2 with public route table

resource "aws_route_table_association" "Bond-public-subnet2-association" {
    subnet_id      = aws_subnet.Bond-public-subnet2.id
    route_table_id = aws_route_table.Bond-route-table-public.id
}


# Public Subnet-1

resource "aws_subnet" "Bond-public-subnet1" {
    vpc_id                  = aws_vpc.Bond_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "eu-west-2a"
    tags = {
        Name = "Bond-public-subnet1"
    }
}

# Public Subnet-2

resource "aws_subnet" "Bond-public-subnet2" {
    vpc_id                  = aws_vpc.Bond_vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "eu-west-2b"
    tags = {
        Name = "Bond-public-subnet2"
    }
}

# Network ACL = A network access control list (ACL) allows or 
# denies specific inbound or outbound traffic at the subnet level.

resource "aws_network_acl" "Bond-network-acl" {
    vpc_id    = aws_vpc.Bond_vpc.id
    subnet_ids = [aws_subnet.Bond-public-subnet1.id, aws_subnet.Bond-public-subnet2.id]

 ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}



