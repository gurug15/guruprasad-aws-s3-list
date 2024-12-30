

module "instance" {
  source = "./modules/ec2"
  ami_id = "ami-053b12d3152c0cc71"
  instance_type = "t2.micro"
  key_name = "WebKey"
  s3_bkt_name = var.S3_BUCKET_NAME
  default_vpc_id = module.loadbalancer.default_vpc_id
  ec2_instance_profile = module.iam_role.ec2_instance_profile

  
}
module "loadbalancer" {
  source = "./modules/alb"
  target_instance_id = module.instance.ec2_instance_id
}

module "iam_role" {
  source = "./modules/iam"

}



output "instance_id" {
  value = module.instance.ec2_instance_id
}

output "default_vpc_id" {
  value = module.loadbalancer.default_vpc_id
}

output "ec2_instance_profile" {
  description = "instance profie"
  value = module.iam_role.ec2_instance_profile
}