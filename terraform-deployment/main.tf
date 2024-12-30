resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile  = aws_iam_instance_profile.ec2_profile.name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nodejs npm git

    # Install TypeScript globally
    npm install -g typescript

    cd /home/ec2-user
    git clone ${var.repo_url} app
    cd app
    
    # Install dependencies and TypeScript locally
    npm install
    npm install typescript @types/node --save-dev
    
    # Initialize TypeScript configuration if not exists
    npx tsc --init

    # Build TypeScript files (assuming your package.json has build script)
    npm run build
    npm start
    EOF
  )

  tags = {
    Name = "s3-list-service"
  }
}