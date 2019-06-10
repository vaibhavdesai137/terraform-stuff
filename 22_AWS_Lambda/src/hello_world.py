import os

# Read the env var that was passed from terraform script that created the lambda function
def lambda_handler(event, context):
    return "{} from lambda function".format(os.environ["greeting"])
