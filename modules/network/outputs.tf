output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.my_vpc.cidr_block
}

output "public_subnet_ids" {
  value = [aws_subnet.public_sub1.id, aws_subnet.public_sub2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_sub1.id, aws_subnet.private_sub2.id]
}
