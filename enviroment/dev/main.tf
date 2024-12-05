terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.74.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      dono    = "queite"
      projeto = "ada-contabil"
    }
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  vpc_id      = aws_vpc.contabil_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "contabil_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.contabil_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.contabil_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}