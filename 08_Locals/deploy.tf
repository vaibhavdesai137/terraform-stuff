
# All Providers
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

# Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

# All Variables
variable multi-region-deploy {
  default = true
}
variable us-east-1-ami {
  default = "ami-2757f631"
}
variable us-east-1-zones {
  default = ["us-east-1a", "us-east-1b"]
}
variable instance-type {
  default = "t2.micro"
}
variable instance-name {
  default = "placeholder-ec2-instance"
}

# All Locals
# Local values assign a name to an expression, that can then be used multiple times within a module.
locals {
  frontend_instance_name = "${replace(var.instance-name, "placeholder", "frontend")}"
  backend_instance_name  = "${replace(var.instance-name, "placeholder", "backend")}"
}

resource "aws_instance" "frontend" {
  tags {
    Name = "${local.frontend_instance_name}"
  }
  count                 = "1"
  availability_zone     = "${var.us-east-1-zones[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "backend" {
  tags {
    Name = "${local.backend_instance_name}"
  }
  count                 = "${var.multi-region-deploy ? 1 : 0}"
  availability_zone     = "${var.us-east-1-zones[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

output "frontend-ips" {
  value = "${aws_instance.frontend.*.public_ip}"
}

output "backend-ips" {
  value = "${aws_instance.backend.*.public_ip}"
}

# terraform init
# terraform apply (create resources)
# terraform output (show our output variables)
# terraform show (render local state)
# terraform destroy (delete everything)
