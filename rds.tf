resource "aws_db_subnet_group" "mysql" {
  name       = "Mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
  tags       = {
    name     = "Mysql DB subnet grp"
  }
}


resource "aws_rds_cluster_parameter_group" "mysql" {
  name   = "mysql-cluster-pg-${var.ENV}"
  family = "aurora-mysql5.7"
  description = "RDS default cluster parameter group"
}

resource "aws_rds_cluster" "mysql" {
  cluster_identifier              = "mysql-${var.ENV}"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.03.2"
  db_subnet_group_name            = aws_db_subnet_group.mysql.name
  database_name                   = "defaultdb"
  master_username                 = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["MYSQL_USER"]
  master_password                 = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["MYSQL_PASS"]
  backup_retention_period         = 5
  preferred_backup_window         = "07:00-09:00"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql.name
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "mysql-${var.ENV}-${count.index}"
  cluster_identifier = aws_rds_cluster.mysql.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.mysql.engine
  engine_version     = aws_rds_cluster.mysql.engine_version
}