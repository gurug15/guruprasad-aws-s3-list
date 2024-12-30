variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default = "https://github.com/gurug15/guruprasad-aws-s3-list.git"
}

variable "repo_url" {
  description = "GitHub repository URL"
  type        = string
}

# outputs.tf
output "elb_dns_name" {
  value = module.elb.lb_dns_name
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}