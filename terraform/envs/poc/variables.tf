variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "gateway_vpc_cidr" {
  description = "CIDR block for Gateway VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "backend_vpc_cidr" {
  description = "CIDR block for Backend VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by both VPCs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "gateway_cluster_name" {
  description = "EKS Gateway cluster name"
  type        = string
  default     = "eks-gateway"
}

variable "backend_cluster_name" {
  description = "EKS Backend cluster name"
  type        = string
  default     = "eks-backend"
}
