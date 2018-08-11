
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
  alias      = "us-east-1"
}

provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-west-1"
  alias      = "us-west-1"
}

resource "aws_instance" "us_east_instance" {
  provider      = "aws.us-east-1"
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
}

resource "aws_instance" "us_west_instance" {
  provider      = "aws.us-west-1"
  ami           = "ami-07585467"
  instance_type = "t2.micro"
}

# terraform init
# terraform apply (create resources)
# terraform show (render local state)
# terraform destroy (delete everything)
