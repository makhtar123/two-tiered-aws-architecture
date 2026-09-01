variable "aws_region" {
  description = "AWS region in which to deploy the infrastructure."
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "Local AWS CLI profile Terraform uses for authentication."
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket used to store Terraform state."
  type        = string
}
