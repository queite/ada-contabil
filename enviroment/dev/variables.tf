variable "bucket_name" {
  type        = string
  default     = "ada-contabil-files"
}

variable "sns_topic_name" {
  type        = string
  default     = "upload_files_to_s3"
}

variable "upload_to_s3_queue_name" {
  type        = string
  default     = "upload_to_s3_queue"
}