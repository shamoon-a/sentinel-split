resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = var.cluster_role_arn


  vpc_config {
    subnet_ids              = var.subnets
    security_group_ids      = [var.sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}


resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnets


  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }


  instance_types = ["t3.medium"]
}


output "cluster_name" { value = aws_eks_cluster.this.name }