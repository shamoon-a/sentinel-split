output "gateway_vpc_id" {
  description = "Gateway VPC ID"
  value       = module.gateway_vpc.vpc_id
}

output "backend_vpc_id" {
  description = "Backend VPC ID"
  value       = module.backend_vpc.vpc_id
}

output "gateway_cluster_name" {
  description = "EKS Gateway cluster name"
  value       = module.eks_gateway.cluster_name
}

output "backend_cluster_name" {
  description = "EKS Backend cluster name"
  value       = module.eks_backend.cluster_name
}

output "gateway_vpc_cidr" {
  description = "Gateway VPC CIDR"
  value       = module.gateway_vpc.cidr
}

output "backend_vpc_cidr" {
  description = "Backend VPC CIDR"
  value       = module.backend_vpc.cidr
}

output "gateway_private_rt" {
  value = module.gateway_vpc.private_route_table_id
}

output "backend_private_rt" {
  value = module.backend_vpc.private_route_table_id
}
