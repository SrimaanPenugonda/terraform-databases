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