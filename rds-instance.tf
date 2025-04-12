# Create RDS Instance
resource "aws_db_instance" "csye6225_db" {
  identifier             = var.db_identifier
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  password               = random_password.db_password.result
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  parameter_group_name   = aws_db_parameter_group.db_params.name
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds_key.arn

  skip_final_snapshot = true
}

# DB Parameter Group
resource "aws_db_parameter_group" "db_params" {
  name   = "csye6225-db-params"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "csye6225-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

# ------------------------------------------------------

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%$"
}

resource "random_string" "secret_name_db" {
  length  = 5
  special = false
}

resource "aws_secretsmanager_secret" "db_password_secret" {
  name       = "${random_string.secret_name_db.result}-db-password"
  kms_key_id = aws_kms_key.secrets_manager_key.arn
}

resource "aws_secretsmanager_secret_version" "db_password_secret_version" {
  secret_id = aws_secretsmanager_secret.db_password_secret.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id  = aws_secretsmanager_secret.db_password_secret.id
  depends_on = [aws_secretsmanager_secret_version.db_password_secret_version]
}