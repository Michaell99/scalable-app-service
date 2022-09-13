variable "aws_region" {
  description = "The Aws region we are going to use"
  type = string
  default = "us-east-1"
}
variable "port_list" {
  description = "List of ports"
  type = list(any)
  default = ["80", "90", "443"]
}

variable "instance_size"{
  description = "The size of the EC2 instance"
  type = string
  default = "t2.micro"
}

variable "security_group" {
  description = "security group name"
  type = string
  default = "Project security group"
}

variable "tags" {
  description = "tags for my project"
  default = {
    Owner = "Michael"
  Environment = "Prod"
  Project = "Prod-app"
  }
}

variable "db_name" {
  description = "name of the database"
  type = string
  default = "aws_database_project"
}
