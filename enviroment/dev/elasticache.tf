resource "aws_elasticache_cluster" "contabil" {
  cluster_id           = var.elasticache_cluster_id
  engine               = var.elasticache_engine
  node_type            = var.elasticache_node_type
  num_cache_nodes      = var.elasticache_num_cache_nodes
  parameter_group_name = var.elasticache_parameter_group_name

  security_group_ids = [aws_security_group.elasticache_sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.elasticache_subnet_group.name
}
