terraform {
  required_version = ">=1.11.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28"
    }
  }
  backend "s3" {
    bucket = "protfolio-bucket-23-ap-south-1"
    key    = "terraform/terraform.tfstate"
    # dynamodb_table = "terraform-lock-table"
    use_lockfile = true
    region       = "ap-south-1"
    encrypt      = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}