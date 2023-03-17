# A provider in Terraform is a plugin that enables interaction with an API. 
# includes Cloud providers and Software-as-a-service providers,
# They tell Terraform which services it needs to interact with.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      region = "us-east-1"
    }
  }
}








