# variables.tf

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-locks"
}

variable "iam_user_name" {
  description = "Name of the IAM user for Terraform operations"
  type        = string
  default     = "terraform-backend-user"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    ManagedBy = "Terraform"
  }
}
