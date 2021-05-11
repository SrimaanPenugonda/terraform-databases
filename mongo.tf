resource "aws_instance" "mongo" {
  ami               = data.aws_ami.ami.id
  instance_type     = "t3.small"
}

resource "aws_security_group" "allow_mongo" {
  name        = "allow-mongo-${var.ENV}"
  description = "allow-mongo-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
  ingress {
    description = "SSH"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR,data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-mongo-${var.ENV}"
  }
}