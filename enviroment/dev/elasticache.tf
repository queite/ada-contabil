resource "aws_elasticache_cluster" "contabil" {
  cluster_id           = var.elasticache_cluster_id
  engine               = var.elasticache_engine
  node_type            = var.elasticache_node_type
  num_cache_nodes      = 2
  parameter_group_name = var.elasticache_parameter_group_name
  port                 = 6379
}
