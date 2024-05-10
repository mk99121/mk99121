data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
module "ec2-instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = var.instances

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = each.value.instance_type
  availability_zone           = module.vpc.availability_zone[0]
  subnet_id                   = "${module.vpc.public_subnet_ids}"
  vpc_security_group_ids      = [aws_security_group.main.id]
  associate_public_ip_address = true
   

  user_data_base64            = "${file("user_data.sh")}"
  user_data_replace_on_change = true

/*  cpu_options = {
    core_count       = 2
    threads_per_core = 1
  }
  enable_volume_tags = false */

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 8
      tags = {
        Name = "my-root-block"
      }
    },
  ]

 /* ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = true
      kms_key_id  = aws_kms_key.this.arn
      tags = {
        MountPoint = "/mnt/data"
      }
    }
  ]

  tags = local.tags
*/
}