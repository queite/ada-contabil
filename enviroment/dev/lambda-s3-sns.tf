data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "s3_full_access_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_s3_file.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_bucket.arn
}

resource "aws_lambda_function" "process_s3_file" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "process_s3_file"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  runtime          = "python3.8"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.upload-file-to-s3.arn
    }
  }
}

data "aws_iam_policy_document" "allow_sns_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish",
      "sns:ReceiveMessage",
      "sns:DeleteMessage",
    ]
    resources = [
      aws_sns_topic.upload-file-to-s3.arn,
    ]
  }
}

resource "aws_iam_policy" "allow_sns_policy" {
  name        = "allow_sns__policy"
  description = "Allow Lambda send message to SNS"
  policy      = data.aws_iam_policy_document.allow_sns_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "allow_sns_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_sns_policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../../lambda_s3_sns.py"
  output_path = "./lambda_s3_sns.zip"
}