resource "aws_db_instance" "contabil" {
  allocated_storage    = 10
  db_name              = "contabil"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin123"
  skip_final_snapshot  = true
}

resource "aws_iam_role" "rds_proxy_role" {
  name               = "rds_proxy_role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role_policy.json
}

data "aws_iam_policy_document" "rds_proxy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_db_proxy" "db_proxy" {
  name                   = "db-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  vpc_subnet_ids         = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]

  auth {
    iam_auth    = "DISABLED"
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.my_secret.arn
  }
}

resource "aws_secretsmanager_secret" "my_secret" {
  name        = "my_db_secret"
  description = "Database credentials for RDS Proxy"
}

resource "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "admin123"
  })
}
