resource "aws_lambda_function" "process_s3_file" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "process_s3_file"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  runtime          = "python3.8"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "allow_sqs_elasticache_policy" {
  name        = "allow_sqs_elasticache_policy"
  description = "Combined IAM policy for Lambda execution"
  policy      = data.aws_iam_policy_document.allow_sqs_elasticache_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "allow_sqs_elasticache_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_sqs_elasticache_policy.arn
}
