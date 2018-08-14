
# All Providers
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

# All Variables
variable multi-az-deploy {
  default = false
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
  default = ["my", "ec2", "instance"]
}

resource "aws_instance" "frontend" {
  tags {
    Name = "${join("-", var.instance-name)}"
  }
  count                 = "${var.multi-az-deploy ? 2 : 1}"
  availability_zone     = "${var.us-east-1-zones[count.index]}"
  ami                   = "${var.us-east-1-ami}"
  instance_type         = "${var.instance-type}"
}

output "frontend-ips" {
  value = "${aws_instance.frontend.*.public_ip}"
}

# terraform init
# terraform apply (create resources)
# terraform output (show our output variables)
# terraform show (render local state)
# terraform destroy (delete everything)
