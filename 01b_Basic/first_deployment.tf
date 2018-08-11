
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
# terraform init -upgrade (will check and upgrade if needed)

# terraform plan (dry run, no execution)
# terraform plan -out my-create-plan (save the plan)
# terraform apply "my-create-plan" (apply the saved plan)

# terraform show (render local state)
# Go to AWS and change some config for this instance
# terraform refresh (force refresh and update local state)
# terraform show (render local state)

# terraform plan --destroy (dry run, no execution)
# terraform plan --destroy -out my-destroy-plan (dry run, no execution)
# terraform apply "my-destroy-plan" (apply the saved plan)
