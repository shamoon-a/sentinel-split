module "gateway_vpc" {
  source = "../../modules/vpc"
  name   = "vpc-gateway"
  cidr   = "10.0.0.0/16"
  azs    = ["us-east-1a", "us-east-1b"]
}


module "backend_vpc" {
  source = "../../modules/vpc"
  name   = "vpc-backend"
  cidr   = "10.1.0.0/16"
  azs    = ["us-east-1a", "us-east-1b"]
}


# NOTE: Route table IDs may need to be supplied explicitly if permissions restrict lookup


module "eks_gateway" {
  source           = "../../modules/eks"
  name             = "eks-gateway"
  subnets          = module.gateway_vpc.private_subnets
  sg_id            = module.gateway_vpc.eks_sg
  cluster_role_arn = aws_iam_role.eks_gateway_cluster.arn
  node_role_arn    = aws_iam_role.eks_gateway_nodes.arn
}


module "eks_backend" {
  source           = "../../modules/eks"
  name             = "eks-backend"
  subnets          = module.backend_vpc.private_subnets
  sg_id            = module.backend_vpc.eks_sg
  cluster_role_arn = aws_iam_role.eks_backend_cluster.arn
  node_role_arn    = aws_iam_role.eks_backend_nodes.arn
}

module "vpc_peering_gateway_backend" {
  source = "../../modules/vpc-peering"

  # VPC IDs
  vpc_a_id = module.gateway_vpc.vpc_id
  vpc_b_id = module.backend_vpc.vpc_id

  # CIDRs
  cidr_a = module.gateway_vpc.cidr
  cidr_b = module.backend_vpc.cidr

  # 🚨 PRIVATE route tables ONLY
  rt_a = module.gateway_vpc.private_route_table_id
  rt_b = module.backend_vpc.private_route_table_id
}