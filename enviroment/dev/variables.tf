variable "bucket_name" {
  type        = string
  default     = "ada-contabil-files"
}

variable "sns_topic_name" {
  type        = string
  default     = "upload-files-to-s3"
}

variable "upload_to_s3_queue_name" {
  type        = string
  default     = "upload-to-s3-queue"
}

variable "elasticache_cluster_id" {
  type        = string
  default     = "contabil"
}

variable "elasticache_engine" {
  type        = string
  default     = "redis"
}

variable "elasticache_node_type" {
  type        = string
  default     = "cache.t2.micro"
}
