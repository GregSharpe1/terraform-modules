# outputs.tf

output "s3_bucket_id" {
  value       = aws_s3_bucket.terraform_state.id
  description = "ID of the S3 bucket"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Name of the DynamoDB table"
}

output "iam_user_name" {
  value       = aws_iam_user.terraform_user.name
  description = "Name of the IAM user"
}

output "iam_user_arn" {
  value       = aws_iam_user.terraform_user.arn
  description = "ARN of the IAM user"
}

output "iam_access_key_id" {
  value       = aws_iam_access_key.terraform_user.id
  description = "Access key ID for the IAM user"
  sensitive   = true
}

output "iam_access_key_secret" {
  value       = aws_iam_access_key.terraform_user.secret
  description = "Secret access key for the IAM user"
  sensitive   = true
}

output "backend_configuration" {
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    key            = "terraform.tfstate"
    region         = var.region
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
  }
  description = "Backend configuration for Terraform"
}
