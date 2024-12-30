resource "aws_iam_role" "ec2_s3_readonly_role" {
  name = "ec2-s3-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach S3 Read-Only Policy to the Role
resource "aws_iam_role_policy_attachment" "s3_readonly_attachment" {
  role       = aws_iam_role.ec2_s3_readonly_role.name
  policy_arn = var.policy_arn
}

# Create Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-s3-readonly-instance-profile"
  role = aws_iam_role.ec2_s3_readonly_role.name
}


output "ec2_instance_profile" {
  description = "instance profie"
  value = aws_iam_instance_profile.ec2_instance_profile.name
}