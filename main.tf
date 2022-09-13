terraform {
  required_version = "1.2.7"
  backend "s3"{
    bucket = "mcl-terraform-remote-state" #Where to save terraform state
    key ="dev/webserver/terraform.tfstate" #Object name in the bucket to Save Terraform state
    region = "us-east-1"  //Region Where bucket created
   }
}

# configuring the AWS provider
provider "aws" {
        region = var.aws_region
  }

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_size
  vpc_security_group_ids = [aws_security_group.web.id]
  tags = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web" {
  name = var.security_group
  description = "security group for aws_instance"
  dynamic "ingress" {
    for_each = var.port_list
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_autoscaling_group" "Project_web" {
  name = "Project-auto_scaling"
  max_size = 5
  min_size = 2
  health_check_type = "ELB"
  health_check_grace_period = 300
  desired_capacity = 3
  launch_template {
    id = aws_instance.web.id
    version = "$Latest"
  }
}

resource "aws_vpc" "Project_web" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    name = "prod-vpc"
  }

}
resource "aws_subnet" "Project_web" {
  vpc_id = aws_vpc.Project_web.id
  tags = {
    Name = "prod-subnet-public"
  }
}