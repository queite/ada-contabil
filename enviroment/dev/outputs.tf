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

output "ELASTICACHE_CLUSTER_ENDPOINT" {
  value       = aws_elasticache_cluster.contabil.cache_nodes[0].address
  description = "Elasticache Cluster Endpoint"
}

output "LAMBDA_FUNCTION_ARN" {
  value       = aws_lambda_function.process_s3_file
  description = "Lambda Function ARN"
}
