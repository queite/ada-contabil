output "S3_BUCKET_NAME" {
  value       = aws_s3_bucket.s3_bucket.bucket
  description = "S3 Bucket Name"
}

output "S3_BUCKET_ARN" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "S3 Bucket ARN"
}

output "SNS_TOPIC_ARN" {
  value       = aws_sns_topic.upload-file-to-s3.arn
  description = "SNS Topic ARN"
}

output "SNS_SUBSCRIPTION_ARN" {
  value = aws_sns_topic_subscription.s3_upload_sns_subs.arn
  description = "SNS Subscription ARN"
}

output "SQS_QUEUE_ARN" {
  value       =aws_sqs_queue.terraform_queue.arn
  description = "SNS Queue ARN"
}