terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48"
    }
  }

  required_version = ">= 0.15.0"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

variable "staging_public_key_path" {
  description = "Staging environment public key absolute file path"
  type        = string
}

variable "production_public_key_path" {
  description = "Production environment public key absolute file path"
  type        = string
}

variable "base_ami_id" {
  description = "Base AMI ID"
  type        = string
}

data "local_file" "staging_public_key_value" {
  filename = var.staging_public_key_path
}

data "local_file" "production_public_key_value" {
  filename = var.production_public_key_path
}

resource "aws_key_pair" "staging_key" {
  key_name   = "staging-key"
  public_key = data.local_file.staging_public_key_value.content

  tags = {
    "Name" = "staging_public_key"
  }
}

resource "aws_instance" "staging_cicd_demo" {
  ami                    = var.base_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d2411db69a112a30"]
  key_name               = aws_key_pair.staging_key.key_name

  tags = {
    "Name" = "staging_cicd_demo"
  }
}

resource "aws_key_pair" "production_key" {
  key_name   = "production-key"
  public_key = data.local_file.production_public_key_value.content

  tags = {
    "Name" = "production_public_key"
  }
}

resource "aws_instance" "production_cicd_demo" {
  ami                    = var.base_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d2411db69a112a30"]
  key_name               = aws_key_pair.production_key.key_name

  tags = {
    "Name" = "production_cicd_demo"
  }
}

output "staging_dns" {
  value = aws_instance.staging_cicd_demo.public_dns
}

output "production_dns" {
  value = aws_instance.production_cicd_demo.public_dns
}
