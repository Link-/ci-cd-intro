variable "region" {
  type    = string
  default = "eu-west-1"
}

// creates a formatted timestamp to keep your AMI name unique.
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "webserver" {
  ami_name      = "node-nginx-webserver-${local.timestamp}"
  source_ami    = "ami-0a8e758f5e873d1c1"
  instance_type = "t2.micro"
  region        = var.region
  ssh_username  = "ubuntu"

  tags = {
    Name = "node-nginx-webserver-${local.timestamp}"
  }
}

build {
  sources = ["source.amazon-ebs.webserver"]

  provisioner "shell" {
    script = "./setup.sh"
  }
}
