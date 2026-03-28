terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
       version = "~>6.32.0 "    }
  }
  backend "s3" {
    bucket = "col-lms-project-2026"
    key = "col-lms-project-2026/state.file/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    
  }
}

provider "aws" {
  profile = "default"
  region = var.provider_region
}