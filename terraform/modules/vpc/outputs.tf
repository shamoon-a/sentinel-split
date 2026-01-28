# Outputs

output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "public_subnet" {
  value = aws_subnet.public.id
}

output "eks_sg" {
  value = aws_security_group.eks.id
}

output "cidr" {
  value = var.cidr
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}