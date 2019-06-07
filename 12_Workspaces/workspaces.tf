
provider "aws" {
  region = "us-east-1"
}

// If in "default" workspace, the default_name will be "default-workspace"
// If in "foobar" workspace, the default_name will be "foobar-workspace"
locals {
  default_name = "${join("-", list(terraform.workspace, "workspace"))}"
}

resource "aws_instance" "example" {
  tags = {
    Name = "${local.default_name}"
  }
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

# terraform workspace list
# terraform workspace new sample-workspace
