
terraform {
  backend "s3" {
    bucket 	= "terraform-demo-vaibhav"
    key    	= "14_Exercise/terraform.tfstate"
    region 	= "us-east-1"
  }
}

locals {
  regions = {
    staging = "us-west-1"
    prod 	= "us-east-1"
  }
  instance_count = {
    staging = "1"
    prod 	= "2"
  }
  amis = {
  	staging = "ami-07585467"
    prod 	= "ami-66506c1c"
  }
  key_names = {
  	staging = "vaibhavdesai137-aws-us-west-1"
    prod 	= "vaibhavdesai137-aws-us-east-1"
  }
  private_keys = {
  	staging = "/Users/vaibhav/.ssh/vaibhavdesai137-aws-us-west-1.pem"
    prod 	= "/Users/vaibhav/.ssh/vaibhavdesai137-aws-us-east-1.pem"
  }
  sg_ids {
  	staging = "sg-4e201436"
    prod 	= "sg-03ec3e58b1a1fc8f3"
  }
}

module "backend" {
  source 		       = "./backend"
  region           = "${local.regions[terraform.workspace]}"
  number_instances = "${local.instance_count[terraform.workspace]}"
  ami 			       = "${local.amis[terraform.workspace]}"
  key_name 		     = "${local.key_names[terraform.workspace]}"
  private_key 	   = "${local.private_keys[terraform.workspace]}"
  sg_id			       = "${local.sg_ids[terraform.workspace]}"
}

module "frontend" {
  source 		       = "./frontend"
  region           = "${local.regions[terraform.workspace]}"
  number_instances = "${local.instance_count[terraform.workspace]}"
  ami 			       = "${local.amis[terraform.workspace]}"
  key_name 		     = "${local.key_names[terraform.workspace]}"
  private_key 	   = "${local.private_keys[terraform.workspace]}"
  sg_id			       = "${local.sg_ids[terraform.workspace]}"
}

output "workspace" {
  value = "${terraform.workspace}"
}

output "frontend_ips" {
  value = "${terraform.workspace}: ${module.frontend.ips}"
}

output "backend_ips" {
  value = "${module.backend.ips}"
}

# terraform workspace new staging
# terraform workspace new prod
# terraform init
# terraform apply
# terraform destroy
