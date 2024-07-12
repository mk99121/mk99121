module "vpc" {
  source = "./module-vpc"
  name   = var.name
  
  environment               = var.environment
  cidr_block                = var.cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones = var.availability_zones

}
