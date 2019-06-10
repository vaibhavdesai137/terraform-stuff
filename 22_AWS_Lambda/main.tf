
provider "aws" {
  region = "us-east-1"
}

// Read from terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Will use to zip our src folder
provider archive {}

// Create a zip from our src file
data "archive_file" "zip" {
  type          = "zip"
  source_file   = "src/hello_world.py"
  output_path   = "hello_world.zip"
}

// Create the required IAM role for lambda function
resource "aws_iam_role" "my_iam_policy" {
  name = "my_iam_policy"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }]
}
EOF
}

// Lambda function definition
// This will just create a function but won't execute it
// We can add triggers via terraform to execute the lambda but that's too much circus
// Just log on to aws console, create a "test" for the lambda & execute the test
resource "aws_lambda_function" "my_lambda_function" {
  
  function_name = "my_lambda_function"

  // To ensure integrity
  filename      = "${data.archive_file.zip.output_path}"  
  source_code_hash = "${data.archive_file.zip.output_sha}"

  role          = "${aws_iam_role.my_iam_policy.arn}"

  // Function to execute in the src (filename.function)
  handler       = "hello_world.lambda_handler"

  runtime = "python3.6"

  environment {
    variables = {
      greeting = "howdy"
    }
  }
}
