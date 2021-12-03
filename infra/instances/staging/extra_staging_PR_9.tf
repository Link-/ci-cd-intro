#
# This is a template for creating on-demand staging EC2 instances. 
# this file relies on resources defined in main.tf and cannot be used standalone.
# ensure that the random id placeholder is replaced with a unique identifier 
# in every copy of this file otherwise new resouces will NOT be created.
# 
# In order to destroy the resources created by this file, just delete
# the copy belong to the resources you wish to destroy and apply the 
# changes.
#
resource "random_id" "server_PR_9" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "${var.base_ami_id}"
  }

  byte_length = 8
}

resource "aws_instance" "staging_cicd_demo_PR_9" {
  # Read the AMI id "through" the random_id resource to ensure that
  # both will change together.
  ami                    = random_id.server_PR_9.keepers.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d2411db69a112a30"]
  key_name               = aws_key_pair.staging_key.key_name

  tags = {
    "Name" = "staging_cicd_demo-${random_id.server_PR_9.hex}"
  }
}

output "staging_dns_PR_9" {
  value = aws_instance.staging_cicd_demo_PR_9.public_dns
}
