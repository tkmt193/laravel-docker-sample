terraform {
  backend "s3" {
    # profile = "tsukamoto-for-windows"
    bucket = "laravel-sample-tfstate-tkmt193"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }
  required_version = "~> 1"
}
