resource "aws_elasticache_cluster" "contabil" {
  cluster_id           = var.elasticache_cluster_id
  engine               = var.elasticache_engine
  node_type            = var.elasticache_node_type
  num_cache_nodes      = var.elasticache_num_cache_nodes
  parameter_group_name = var.elasticache_parameter_group_name

  security_group_ids = [aws_security_group.elasticache_sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.elasticache_subnet_group.name
}

resource "aws_security_group" "elasticache_sg" {
  name        = "elasticache_sg"
  description = "Allow access to Elasticache cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "elasticache_subnet_group"
  subnet_ids = var.subnet_ids
  description = "Elasticache subnet group"
}
