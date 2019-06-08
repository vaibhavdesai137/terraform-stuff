
provider "aws" {
  region = "us-east-1"
}

// Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Path in which to create the user
variable "path" {  
  default = "/"
}

# When destroying this user, destroy even if it has non-terraform-managed IAM access keys, login profile or MFA devices
variable "force_destroy" {
  default = false
}

// Create a new user
resource "aws_iam_user" "newuser" {
  name          = "newuser"
  path          = "${var.path}"
  force_destroy = "${var.force_destroy}"
}

// Create a new group
resource "aws_iam_group" "newgroup" {
  name  = "newgroup"
}

// Attach policy to the new group
// This will grant "EC2 decsribe" permissions
resource "aws_iam_group_policy" "foo" {
  group   = "${aws_iam_group.newgroup.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Action": ["ec2:Describe*"],
      "Effect": "Allow",
      "Resource": "*"
    }]
}
EOF
}

// Add the new user to the new group
resource "aws_iam_group_membership" "foo" {
  name  = "foobar"
  group = "${aws_iam_group.newgroup.id}"
  users = ["${aws_iam_user.newuser.id}"]
}
