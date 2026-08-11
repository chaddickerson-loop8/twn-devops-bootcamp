variable "aws_region" {
  description = "AWS region to create the state bucket and lock table in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform remote state. Must be filled in with a real, available name before applying."
  type        = string
  default     = "chaddickerson-twn-devops-tfstate"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "twn-devops-bootcamp-tfstate-lock"
}
