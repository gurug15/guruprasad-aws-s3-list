
resource "aws_security_group" "expose-port" {
  name   = "s3-listing-sg"
  vpc_id = var.default_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "application" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.expose-port.id]
  key_name        = var.key_name
  iam_instance_profile = var.ec2_instance_profile

  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y nodejs npm git
export S3_BUCKET_NAME=${var.s3_bkt_name}
cd /home/ubuntu
mkdir application
cd application
sudo npm install -g typescript
git clone https://github.com/gurug15/guruprasad-aws-s3-list.git .
cd app
npm install
npm run dev
EOF

  tags = {
    Name = "Main-application"
  }
}