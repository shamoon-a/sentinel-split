variable "vpc_a_id" {}
variable "vpc_b_id" {}
variable "cidr_a" {}
variable "cidr_b" {}
variable "rt_a" {}
variable "rt_b" {}


resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.vpc_a_id
  peer_vpc_id = var.vpc_b_id
  auto_accept = true
}


resource "aws_route" "a_to_b" {
  route_table_id            = var.rt_a
  destination_cidr_block    = var.cidr_b
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}


resource "aws_route" "b_to_a" {
  route_table_id            = var.rt_b
  destination_cidr_block    = var.cidr_a
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}