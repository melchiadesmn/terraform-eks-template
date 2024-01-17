output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "VPC ID"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
  description = "Private subnets IDs"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
  description = "Public subnets IDs"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main_igw.id
  description = "Internet Gateway ID"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.main_nat_gateway[*].id
  description = "NAT Gateway ID"
}

output "nat_gateway_ips" {
  value       = aws_nat_gateway.main_nat_gateway[*].public_ip
  description = "NAT Gateway IP ID"
}

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "Public route table ID"
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "Private route table ID"
}
