terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"


  backend "s3" {
    bucket         = "jho-terraform"
    key            = "landing-zone/general/terraform.tfstate"
    region         = "us-east-2"
  }

}

