provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

data "archive_file" "parquet_job" {
  type        = "zip"
  output_path = "../lambda/pre/glue_parquet_job.zip"

  source {
    filename = "glue_parquet_job.py"
    content  = file("../lambda/pre/glue_parquet_job.py")
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_glue" {
  name        = "lambda_glue"
  path        = "/"
  description = "IAM policy for run glue jobs from lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "glue:*",
      "Resource": "arn:aws:glue:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "${aws_iam_policy.lambda_glue.arn}"
}

resource "aws_lambda_function" "glue_parquet_job" {
  function_name    = "lambda_glue_parquet_job"
  filename         = data.archive_file.parquet_job.output_path
  source_code_hash = data.archive_file.parquet_job.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.8"
  handler          = "glue_parquet_job.lambda_handler"
  memory_size      = 128
  timeout          = 3
  publish          = true

  # tags = {
  #   Project    = "app-web"
  #   Env        = var.env_name
  #   Squad      = local.squad
  #   SquadGroup = local.squad_group
  #   CostCenter = local.costcenter
  #   Terraform  = true
  # }
}

# resource "aws_lambda_function" "test_lambda" {
#   # filename      = "../lambda.zip"
#   s3_bucket     = "lambda-bucket-jho"
#   s3_key        = "lambda.zip"
#   function_name = "lambda_function_name2"
#   role          = aws_iam_role.iam_for_lambda.arn
#   handler       = "exports.test"

#   runtime = "nodejs12.x"

#   environment {
#     variables = {
#       foo = "bar2"
#     }
#   }
# }