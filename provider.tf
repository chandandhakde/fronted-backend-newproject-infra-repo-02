terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
       version = "~>6.32.0 "    }
  }
  backend "s3" {
    bucket = "col-lms-project-s3-bucket-01"
    key = "col-lms-project-s3-bucket-01/state.file/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    
  }
}

provider "aws" {
  profile = ""
  region = var.provider_region
}
