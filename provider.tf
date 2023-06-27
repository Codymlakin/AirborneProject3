terraform {
  backend "s3" {
    bucket = "eaglesbackend"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
    profile = "cmlakin"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}