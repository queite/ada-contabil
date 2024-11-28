resource "aws_lambda_function" "process_s3_file" {
  filename         = "lambda_function_payload.zip"
  function_name    = "process_s3_file"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime          = "python3.8"
  environment {
    variables = {
      S3_BUCKET_NAME = var.bucket_name
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_exec_policy" {
  name        = "lambda_exec_policy"
  description = "IAM policy for Lambda execution"
  policy      = data.aws_iam_policy_document.lambda_exec_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

data "aws_iam_policy_document" "lambda_exec_policy" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.terraform_queue.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_elasticache_policy" {
  name        = "lambda_elasticache_policy"
  description = "IAM policy for Lambda to access ElastiCache"
  policy      = data.aws_iam_policy_document.lambda_elasticache_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_elasticache_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_elasticache_policy.arn
}

data "aws_iam_policy_document" "lambda_elasticache_policy" {
  statement {
    actions = [
      "elasticache:*"
    ]
    resources = [
      "*"
    ]
  }
}
