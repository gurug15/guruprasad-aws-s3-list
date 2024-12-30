#!/bin/bash
sudo apt update -y
suod apt  install -y nodejs npm git
cd /home/ubuntu
mkdir applicatioin
export S3_BUCKET_NAME=guru-tetris-example
cd applicatioin
sudo npm install -g typescript
git clone https://github.com/gurug15/guruprasad-aws-s3-list.git .
cd app
npm install
npm run dev