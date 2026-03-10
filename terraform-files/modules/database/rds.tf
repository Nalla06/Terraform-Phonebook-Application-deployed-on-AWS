resource "aws_db_instance" "rds" {
  identifier              = "phonebook-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                    = "phonebook"
  username                = "admin"
  password                = var.db_password
  allocated_storage       = 20
  vpc_security_group_ids  = [var.rds_sg_id]
  publicly_accessible     = false
  db_subnet_group_name   = aws_db_subnet_group.default_db_subnet_group.name
  skip_final_snapshot     = true
}
# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# Create a DB subnet group for default subnets
resource "aws_db_subnet_group" "default_db_subnet_group" {
  name       = "default-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
  tags = {
    Name = "Default DB Subnet Group"
  }
}
