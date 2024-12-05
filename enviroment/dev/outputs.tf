output "S3_BUCKET_NAME" {
  value       = aws_s3_bucket.s3_bucket.bucket
  description = "S3 Bucket Name"
}

output "S3_BUCKET_ARN" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "S3 Bucket ARN"
}

output "SNS_TOPIC_ARN" {
  value       = aws_sns_topic.upload_file_to_s3.arn
  description = "SNS Topic ARN"
}

output "SNS_TO_SQS_SUBSCRIPTION_ARN" {
  value = aws_sns_topic_subscription.s3_upload_sns_to_sqs.arn
  description = "SNS Subscription ARN"
}

output "SQS_QUEUE_ARN" {
  value       =aws_sqs_queue.new_object_queue.arn
  description = "SNS Queue ARN"
}

output "LAMBDA_FUNCTION_ARN" {
  value       = aws_lambda_function.process_s3_file.arn
  description = "Lambda Function ARN"
}

output "RDS_DB_NAME" {
  value = aws_db_proxy.db_proxy.name
}
output "RDS_PROXY_ENDPOINT" {
  value = aws_db_proxy.db_proxy.endpoint
}

output "RDS_USERNAME" {
  value = aws_db_instance.contabil.username
}

output "RDS_PASSWORD" {
  value = aws_db_instance.contabil.password
  sensitive = true
}