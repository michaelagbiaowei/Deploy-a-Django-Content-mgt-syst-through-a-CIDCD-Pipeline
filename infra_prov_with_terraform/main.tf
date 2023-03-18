terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.53.0"
    }
  }
}

provider "aws" {
  region     = var.region
}

# VPC = allows you to secure your virtual networking environment,
#       includes your IP addresses, subnets and network gateways. 

resource "aws_vpc" "django_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "django_vpc"
      }
}

# Internet Gateway a horizontally scaled, redundant,and highly available VPC component 
# that allows communication between your VPC and the internet

  resource "aws_internet_gateway" "django_internet_gateway" {
    vpc_id = aws_vpc.django_vpc.id
    tags ={
        Name = "django_internet_gateway"
    }
  }


  # Public Route Table = route table contains a set of rules (also known as routes) 
  # that are used to determine where network traffic is directed. 

  resource "aws_route_table" "django-route-table-public" {
    vpc_id = aws_vpc.django_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.django_internet_gateway.id
    }

    tags = {
        Name = "django-route-table-public"
    }
  }

#  Public subnet 1 with public route table = a subnet that's associated with a route table
#  that has a route to an internet gateway

resource "aws_route_table_association" "django-public-subnet1-association" {
    subnet_id      = aws_subnet.django-public-subnet1.id
    route_table_id = aws_route_table.django-route-table-public.id
}


# Public subnet 2 with public route table

resource "aws_route_table_association" "django-public-subnet2-association" {
    subnet_id      = aws_subnet.django-public-subnet2.id
    route_table_id = aws_route_table.django-route-table-public.id
}


# Public Subnet-1

resource "aws_subnet" "django-public-subnet1" {
    vpc_id                  = aws_vpc.django_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags = {
        Name = "django-public-subnet1"
    }
}

# Public Subnet-2

resource "aws_subnet" "django-public-subnet2" {
    vpc_id                  = aws_vpc.django_vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1b"
    tags = {
        Name = "django-public-subnet2"
    }
}

# Network ACL = A network access control list (ACL) allows or 
# denies specific inbound or outbound traffic at the subnet level.

resource "aws_network_acl" "django-network-acl" {
    vpc_id    = aws_vpc.django_vpc.id
    subnet_ids = [aws_subnet.django-public-subnet1.id, aws_subnet.django-public-subnet2.id]

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

# Security Group = A security group acts as a virtual firewall 
# for your EC2 instances to control incoming and outgoing traffic. 

# to allow port 22, 9099, 9093, 9100

resource "aws_security_group" "django-security-grp-rule-1" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP and HTTPS inbound traffic for public instances"
  vpc_id      = aws_vpc.django_vpc.id
  

 ingress {
    description = "HTTP"
    from_port   = 9099
    to_port     = 9099
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


 ingress {
    description = "HTTPS"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
 ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   
  }
}

# Security Group to allow port 22, 80, 443, 9100, 5432

resource "aws_security_group" "django-security-grp-rule-2" {
  name        = "allow_ssh_http_http"
  description = "Allow SSH, HTTP and HTTPS inbound traffic for public instances"
  vpc_id      = aws_vpc.django_vpc.id
  

 ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


 ingress {
    description = "HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
 ingress {
    description = "SSH"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    description = "SSH"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "django-security-grp-rule-2"
  }
}


#  instance 1 = these are virtual machines 

resource "aws_instance" "django1" {
  ami             = "ami-0557a15b87f6559cf"
  key_name        = "volder"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.django-security-grp-rule-1.id]
  subnet_id       = aws_subnet.django-public-subnet1.id
  availability_zone = "us-east-1a"

  tags = {
    Name   = "django-1"
    source = "terraform"
  }
}

# instance 2

 resource "aws_instance" "django2" {
  ami             = "ami-0557a15b87f6559cf"
  key_name        = "volder"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.django-security-grp-rule-2.id]
  subnet_id       = aws_subnet.django-public-subnet2.id
  availability_zone = "us-east-1b"
  

  tags = {
    Name   = "django-2"
    source = "terraform"
  }
}

# To store the IP addresses of the instances

resource "local_file" "Ip_address" {
  filename = "config_mgt_with_ansible/inventory-1"
  content  = <<EOT
${aws_instance.django1.public_ip}
${aws_instance.django2.public_ip}
  EOT
}
