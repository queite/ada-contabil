# Criar um bucket S3
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "new_object_notify" {
  bucket = aws_s3_bucket.s3_bucket.id

  lambda_function  {
    lambda_function_arn = aws_lambda_function.process_s3_file.arn
    events        = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_function.process_s3_file]
}
