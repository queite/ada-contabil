resource "aws_sns_topic" "upload-file-to-s3" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_policy" "s3_sns_policy" {
  arn = aws_sns_topic.upload-file-to-s3.arn
  policy = data.aws_iam_policy_document.topic.json
}

resource "aws_sns_topic_subscription" "s3_upload_sns_subs" {
  topic_arn = aws_sns_topic.upload-file-to-s3.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.terraform_queue.arn
}