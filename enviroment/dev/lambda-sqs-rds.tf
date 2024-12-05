# Lambda layer
# resource "aws_lambda_layer_version" "redis_layer" {
#   filename   = "redis.zip"
#   layer_name = "redis"

#   compatible_runtimes = ["python3.8"]
# }

# Lambda role
data "aws_iam_policy_document" "sqs_rds_lambda_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_sqs_rds" {
  name = "iam_for_lambda_sqs_rds"
  assume_role_policy = data.aws_iam_policy_document.sqs_rds_lambda_role.json
}

# Cloudwatch logs permissions
data "aws_iam_policy_document" "lambda_logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name = "lambda_logging_policy"
  description = "Policy for logging from Lambda functions"
  policy = data.aws_iam_policy_document.lambda_logging_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attach" {
  role = aws_iam_role.iam_for_lambda_sqs_rds.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

# SQS e RDS permissions
resource "aws_iam_role_policy_attachment" "sqs_full_access_attach" {
  role       = aws_iam_role.iam_for_lambda_sqs_rds.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "rds_full_access_attach" {
  role       = aws_iam_role.iam_for_lambda_sqs_rds.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_lambda_function" "save-on-rds" {
  filename         = data.archive_file.lambda_sqs_rds.output_path
  function_name    = "save-on-rds"
  role             = aws_iam_role.iam_for_lambda_sqs_rds.arn
  handler          = "lambda_sqs_rds.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda_sqs_rds.output_path)
  runtime          = "python3.8"
  timeout = 10

  vpc_config {
    subnet_ids         = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
    security_group_ids = [aws_security_group.db_sg.id] 
  }
  # layers           = [aws_lambda_layer_version.redis_layer.arn]

  environment {
    variables = {
      RDS_PROXY_ENDPOINT = aws_db_proxy.db_proxy.endpoint
    }
  }

  # depends_on = [ aws_lambda_layer_version.redis_layer ]
}

resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.save-on-rds.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.new_object_queue.arn
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.new_object_queue.arn
  function_name    = aws_lambda_function.save-on-rds.function_name
  batch_size       = 10
  enabled          = true
}

data "archive_file" "lambda_sqs_rds" {
  type        = "zip"
  source_file = "../../lambda_sqs_rds.py"
  output_path = "./lambda_sqs_rds.zip"
}
