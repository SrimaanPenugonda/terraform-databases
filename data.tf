//this is to connect the VPC information , this can be done by accessing VPC state file which
// is stored in s3
data "terraform_remote_state" "vpc" {
  backend        = "s3"
  config         = {
    bucket       = var.bucket //existing bucket name to access VPC state files
    key          = "vpc/${var.ENV}/terraform.tfstate" //path in bucket
    region       = var.region
  }
}

#get the credentials from AWS secret manager
data "aws_secretsmanager_secret" "creds" {
  name     = "roboshop-${var.ENV}"
}

data "aws_secretsmanager_secret_version" "creds"{
  secret_id = data.aws_secretsmanager_secret.creds.id
}

data "aws_ami" "ami" {
  most_recent   = true
  owners        = ["973714476881"]
  #  filter {
  #    name   = "image-id"
  #    values = ["ami-079a3f3cf00741286"]
  #  }  ami id will change all time so filtering on name
  filter {
    name   = "name"
    values = ["Centos-7-DevOps-Practice"]
  }
}