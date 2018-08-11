
# All Providers
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

# All Variables
variable multi-az-deploy {
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

# All Locals
locals {
  frontend_instance_name = "my-ec2-instance-frontend"
  backend_instance_name  = "my-ec2-instance-backend"
}

resource "aws_instance" "frontend" {
  tags {
    Name = "${local.frontend_instance_name}"
  }
  count                 = "${var.multi-az-deploy ? 2 : 1}"
  availability_zone     = "${var.us-east-1-zones[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

resource "aws_instance" "backend" {
  tags {
    Name = "${local.backend_instance_name}"
  }
  count                 = "${var.multi-az-deploy ? 2 : 1}"
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
