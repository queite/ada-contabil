# Criar um bucket S3
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "new_object_notify" {
  bucket = aws_s3_bucket.s3_bucket.id
  depends_on = [aws_sns_topic_policy.s3_sns_policy]

  topic {
    topic_arn     = aws_sns_topic.upload-file-to-s3.arn
    events        = ["s3:ObjectCreated:*"]
  }
}