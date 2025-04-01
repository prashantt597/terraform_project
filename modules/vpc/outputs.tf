output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_1_id" {
  value = aws_subnet.my_subnet2.id
}

output "public_subnet_2_id" {
  value = aws_subnet.my_subnet4.id
}