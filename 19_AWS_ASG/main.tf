
provider "aws" {
  region = "eu-west-1"
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

// Fetch a random amazon owner AMI (you can hardcode one too)
data "aws_ami" "amazon_ami" {
  
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2"
    ]
  }
}

//
// Launch configuration and autoscaling group (using AWS module)
//
module "autoscaling-example" {
  
  source = "terraform-aws-modules/autoscaling/aws"

  name = "my-autoscaling-example"

  // 
  // Launch configuration:
  // This defines what configurations to use when spinning up new instances
  // You can create one or use existing one (we'll create a new one)
  //
  
  // launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  // create_lc = false # disables creation of launch configuration
  lc_name = "my-lc"

  image_id        = "${data.aws_ami.amazon_ami.id}"
  instance_type   = "t2.micro"
  security_groups = ["${data.aws_security_group.default.id}"]

  // Attach a new volume to our ec2 instance for persistence
  ebs_block_device = [{
    device_name           = "/dev/xvdz"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = true
  }]

  // Also, update the settins for the default volume that will be created when the instance is created
  root_block_device = [{
    volume_size = "50"
    volume_type = "gp2"
  }]

  //
  // Auto scaling group:
  // This defines the policies on when to flex instances
  // If no policies are defined, ASG will use the min/max counts to ensure the desired number of EC2 instances are healthy at all times.
  // Will use the launch configuration when creating new instances
  //
  asg_name                  = "my-asd"
  vpc_zone_identifier       = ["${data.aws_subnet_ids.subnets.ids}"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [{
    key                 = "env"
    value               = "dev"
    propagate_at_launch = true
  }, {
    key                 = "app"
    value               = "foobarapp"
    propagate_at_launch = true
  }]
}
