output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.public_2.id]
}

output "route_table_id" {
  value = aws_route_table.public.id
}
