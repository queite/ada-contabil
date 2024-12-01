data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    # condition {
    #   test     = "StringEquals"
    #   variable = "AWS:SourceOwner"

    #   values = [
    #     var.account-id,
    #   ]
    # }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.upload-file-to-s3.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic" "upload-file-to-s3" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_policy" "s3_sns_policy" {
  arn = aws_sns_topic.upload-file-to-s3.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

# Subscription SNS -> SQS
resource "aws_sns_topic_subscription" "s3_upload_sns_to_sqs" {
  topic_arn = aws_sns_topic.upload-file-to-s3.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.new_object_queue.arn
}