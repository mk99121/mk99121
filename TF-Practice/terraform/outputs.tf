output "vpc-id" {
  value = module.vpc["vpc-1"].vpc_id
  
}

 output "public_subnet_ids" {
   value = module.vpc["vpc-1"].public_subnets
   
 }

 output "availability_zone" {
   value = module.vpc["vpc-1"].azs
 }

 output "security_group_id" {
   value = aws_security_group.main.id
 }

/*output "my_ec2_instance_id" {
   value =  module.ec2_complete.instance_id
}*/