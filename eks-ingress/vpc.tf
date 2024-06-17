module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"



  # VPC Basic Details
  name = var.vpc-name 
  cidr = var.vpc-cidr   
  azs   = var.vpc-azs
  private_subnets     = var.vpc-pvt
  public_subnets      = var.vpc-pub

  # Database Subnets
  create_database_subnet_group = true
  create_database_subnet_route_table= true
  database_subnets    = var.vpc-db

  #create_database_nat_gateway_route = true
  #create_database_internet_gateway_route = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support = true

  public_subnet_tags = {
    Type = var.public_subnet_tags["Name"]
      "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    Type = var.private_subnet_tags["Name"]
  
    "kubernetes.io/role/internal-elb" = 1
  }

  database_subnet_tags = {
    Type = var.database_subnet_tags["Name"]
  }
  

 /* tags = {
    Owner = "krishna"
    Environment = "test"
  }*/

  vpc_tags = {
    Name = "Krishna-VPC"
  }
}

