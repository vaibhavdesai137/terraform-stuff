
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

resource "aws_instance" "myinstance1" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

# terraform validate (check if the .tf file is syntactically/semantically correct)
# terraform init (inits the given providers for making api calls)
# terraform apply (create resources)
# terraform show (render local state)
# terraform refresh (force refresh and update local state)
# terraform show (render local state)
# terraform destroy (delete everything)
