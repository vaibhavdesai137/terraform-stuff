
#
# Uses cnd line to pass variables
# Will create once instance each in "us-east-1a" and "us-east-1c"
#

provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

# will be set by env var TF_VAR_zones  
variable "zones" { 
  type = "list"
}

resource "aws_instance" "myinstance" {
  count                 = 2
  availability_zone     = "${var.zones[count.index]}"
  ami                   = "ami-2757f631"
  instance_type         = "t2.micro"
}

# terraform init
# terraform apply -var 'zones=["us-east-1e", "us-west-1f"]' (create resources)
# terraform show (render local state)
# terraform destroy (delete everything)
