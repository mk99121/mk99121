output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnet_id
}
output "private_subnets" {
  value = module.vpc.privat_esubnet_id
}
