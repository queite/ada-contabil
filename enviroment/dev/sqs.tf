resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name = "${var.upload_to_s3_queue_name}_deadletter"
}

resource "aws_sqs_queue" "new_object_queue" {
  name                      = var.upload_to_s3_queue_name
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "development"
  }

  depends_on = [aws_sns_topic.upload-file-to-s3]
}

data "aws_iam_policy_document" "sqs_sns_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = ["SQS:SendMessage"]

    resources = [aws_sqs_queue.new_object_queue.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [aws_sns_topic.upload-file-to-s3.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "new_object_queue_policy" {
  queue_url = aws_sqs_queue.new_object_queue.id
  policy    = data.aws_iam_policy_document.sqs_sns_policy.json
}