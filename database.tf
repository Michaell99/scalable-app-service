resource "aws_db_instance" "default" {
  allocated_storage = 10
  engine = "mysql"
  instance_class = "db.t3.micro"
  db_name = var.db_name
}