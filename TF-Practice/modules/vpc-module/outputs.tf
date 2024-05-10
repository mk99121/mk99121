output "vpc_id" {
  value = aws_vpc.vpc.id

}
output "gw_id" {
  value = aws_internet_gateway.igw.id
}

output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "privat_esubnet_id" {
  value = aws_subnet.public[*].id
}
