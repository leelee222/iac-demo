variable "bucket_prefix" {
  type        = string
  description = "Prefix for the bucket name"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "local"
}
