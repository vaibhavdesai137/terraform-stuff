
// Uses all defaults set in instances/main.tf
module "frontend" {
  source 		 = "./instances"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
}

// Overrides "total_instances" and "region" set in instances/main.tf
module "backend" {
  source 		  = "./instances"
  total_instances = 2
  region          = "us-west-1"
  aws_access_key  = "${var.aws_access_key}"
  aws_secret_key  = "${var.aws_secret_key}"
}

output "frontnend_ips" {
  value = "${module.frontend.ips}"
}

output "backend_ips" {
  value = "${module.backend.ips}"
}