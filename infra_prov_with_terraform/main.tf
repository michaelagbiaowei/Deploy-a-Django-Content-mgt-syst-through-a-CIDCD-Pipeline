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

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "cluster-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.5.2-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
