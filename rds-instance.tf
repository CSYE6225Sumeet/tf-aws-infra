# Create RDS Instance
resource "aws_db_instance" "csye6225_db" {
  identifier             = var.db_identifier
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  parameter_group_name   = aws_db_parameter_group.db_params.name

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

