

resource "aws_db_subnet_group" "loljoa2-db-sub-group" {
  name       = "loljoa2-db-sub-group"
  subnet_ids = [aws_subnet.loljoa2-pri-sub-a.id, aws_subnet.loljoa2-pri-sub-c.id]

  tags = {
    Name = "loljoa2-db-sub-group"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

# rds create
resource "aws_db_instance" "loljoa2-rds" {
  allocated_storage       = 10
  max_allocated_storage   = 20
  engine                  = "mysql"
  engine_version          = "8.0.27"
  instance_class          = "db.t3.micro"
  username                = "hans"
  password                = "rlawjdgks"
  skip_final_snapshot     = true
  multi_az                = false

  db_subnet_group_name    = aws_db_subnet_group.loljoa2-db-sub-group.id
  vpc_security_group_ids  = [aws_security_group.loljoa2-rds-sg.id]

  tags = {
    Name = "loljoa2-rds"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}
