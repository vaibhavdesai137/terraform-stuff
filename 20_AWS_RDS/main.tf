
//
// THIS DOES NOT WORK. AWS's RDS MODULES ARE NOT UPDATED YET TO SUPPORT TERRAFORM VERSION v0.12.
// https://github.com/terraform-aws-modules/terraform-aws-rds/issues/111
//
// Running this with terraform v0.11 creates the RDS successfully
//

provider "aws" {
  region = "us-east-1"
}

// Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Fetch all VPCs and get the default one
data "aws_vpc" "default" {
  default = true
}

// Fetch all subnets for our vpc
data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.default.id}"
}

// Fetch the default sg associated with our vpc
data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

//
// DB
//
module "db" {
  
  source = "terraform-aws-modules/rds/aws"

  identifier = "my-mysql-db"

  // Create a mysql rds
  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  // DB keys
  name     = "testdb"
  username = "testuser"
  password = "foobarfoobarfoobar123!"
  port     = "3306"

  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]

  // Select maintenance & backup windows
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  // Save only last 10 days of backup
  backup_retention_period = 10

  // Monitoring
  enabled_cloudwatch_logs_exports = ["audit", "general"]

  tags = {
    env = "dev"
  }

  // DB subnet group
  subnet_ids = ["${data.aws_subnet_ids.subnets.ids}"]

  // DB Family
  family = "mysql5.7"
  major_engine_version = "5.7"

  // Snapshot name upon DB deletion
  final_snapshot_identifier = "my-mysql-db"
}
