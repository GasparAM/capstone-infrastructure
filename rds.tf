resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.tf.id

  ingress {
    description     = "MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.tf.id]
  }
}

resource "aws_secretsmanager_secret" "secrets" {
  name                           = "/secrets/db"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = file("./secret.json")
}

resource "aws_secretsmanager_secret" "url" {
  name                           = "/secrets/url"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0

}

resource "aws_secretsmanager_secret_version" "url" {
  secret_id     = aws_secretsmanager_secret.url.id
  secret_string = "{\"MYSQL_URL\":\"jdbc:mysql://${aws_db_instance.mysql.endpoint}/${aws_db_instance.mysql.db_name}\"}"
  depends_on    = [aws_db_instance.mysql]
}

resource "aws_db_instance" "mysql" {
  allocated_storage = 10
  db_name           = "petclinic"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  username               = jsondecode(aws_secretsmanager_secret_version.secrets.secret_string)["MYSQL_USER"]
  password               = jsondecode(aws_secretsmanager_secret_version.secrets.secret_string)["MYSQL_PASS"]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}

resource "local_file" "url" {
  content  = aws_db_instance.mysql.endpoint
  filename = "./ansible/roles/setup/files/url.txt"
}
