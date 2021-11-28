terraform {
  backend "remote" {
    organization = "glich-stream"

    workspaces {
      name = "ci-cd-staging"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48"
    }

    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }

  required_version = ">= 0.15.0"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

variable "staging_public_key" {
  description = "Staging environment public key value"
  type        = string
}

variable "base_ami_id" {
  description = "Base AMI ID"
  type        = string
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "${var.base_ami_id}"
  }

  byte_length = 8
}

resource "aws_key_pair" "staging_key" {
  key_name   = "staging-key"
  public_key = var.staging_public_key

  tags = {
    "Name" = "staging_public_key"
  }
}

# This is the main staging environment. We will deploy to this the changes
# to the main branch before deploying to the production environment.
resource "aws_instance" "staging_cicd_demo" {
  # Read the AMI id "through" the random_id resource to ensure that
  # both will change together.
  ami                    = random_id.server.keepers.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d2411db69a112a30"]
  key_name               = aws_key_pair.staging_key.key_name

  tags = {
    "Name" = "staging_cicd_demo-${random_id.server.hex}"
  }
}

output "staging_dns" {
  value = aws_instance.staging_cicd_demo.public_dns
}
