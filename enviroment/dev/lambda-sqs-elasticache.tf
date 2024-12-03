resource "aws_iam_role" "iam_for_lambda_sqs_elasticache" {
  name = "iam_for_lambda_sqs_elasticache"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "sqs_full_access_attach" {
  role       = aws_iam_role.iam_for_lambda_sqs_elasticache.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "elasticache_full_access_attach" {
  role       = aws_iam_role.iam_for_lambda_sqs_elasticache.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.new_object_queue.arn
  function_name    = aws_lambda_function.process_sqs_message.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_lambda_function" "process_sqs_message" {
  filename         = data.archive_file.lambda_sqs_elasticache.output_path
  function_name    = "process_sqs_message"
  role             = aws_iam_role.iam_for_lambda_sqs_elasticache.arn
  handler          = "lambda_sqs_elasticache.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda_sqs_elasticache.output_path)
  runtime          = "python3.8"

  environment {
    variables = {
      ELASTICACHE_ENDPOINT = aws_elasticache_cluster.contabil.cache_nodes[0].address
    }
  }
}

resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_sqs_message.arn
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.new_object_queue.arn
}

resource "aws_sqs_queue_policy" "allow_lambda_sqs_policy" {
  queue_url = aws_sqs_queue.new_object_queue.id
  policy    = data.aws_iam_policy_document.sqs_sns_policy.json
}

data "archive_file" "lambda_sqs_elasticache" {
  type        = "zip"
  source_file = "../../lambda_sqs_elasticache.py"
  output_path = "./lambda_sqs_elasticache.zip"
}
