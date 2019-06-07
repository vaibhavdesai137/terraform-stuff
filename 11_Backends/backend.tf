
terraform {
  backend "s3" {
    bucket 	= "terraform-demo-vaibhav"
    key    	= "states/terraform.tfstate"
    region 	= "us-east-1"
  }
}

#
# Credentials are being read from ~/.aws directory
# A template of .aws directory is created in this current directory
# Ideally, you should create that in the home directory
#
# You can set multiple profiles with each having its own access/secret key
# export AWS_PROFILE=default
# export AWS_PROFILE=myDev
#
# OR
#
# You can simply create env varibales that terraform will use
# export AWS_ACCESS_KEY_ID="foo"
# export AWS_SECRET_ACCESS_KEY="bar"
#

# All Providers
provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  tags {
    Name = "Terraform-Backends-Demo"
  }
  count                 = "1"
  ami                   = "ami-2757f631"
  instance_type         = "t2.micro"
}