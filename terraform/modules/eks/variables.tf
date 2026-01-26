variable "name" {}
variable "subnets" { type = list(string) }
variable "cluster_role_arn" {}
variable "node_role_arn" {}
variable "sg_id" {}