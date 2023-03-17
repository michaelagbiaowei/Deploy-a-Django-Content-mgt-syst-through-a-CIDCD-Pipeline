# A provider in Terraform is a plugin that enables interaction with an API. 
# includes Cloud providers and Software-as-a-service providers,
# They tell Terraform which services it needs to interact with.

terraform {
  cloud {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  required_version = ">= 1.2.0"
}








