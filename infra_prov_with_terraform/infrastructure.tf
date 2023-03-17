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
  ami             = "ami-0aaa5410833273cfe"
  instance_type   = "t2.micro"
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
  ami             = "ami-0aaa5410833273cfe"
  instance_type   = "t2.micro"
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
