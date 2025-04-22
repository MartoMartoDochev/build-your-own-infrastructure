resource "aws_db_instance" "wordpress" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot  = true
  publicly_accessible  = false
  multi_az             = var.multi_az
  deletion_protection  = false
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  monitoring_role_arn             = var.monitoring_role_arn
  monitoring_interval             = 60
}

resource "aws_db_subnet_group" "default" {
  name       = "wordpress-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}



