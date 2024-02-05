module "vpn" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "v5.1.0"
  name                   = "vpn-${var.environment}"
  ami                    = "ami-05fb0b8c1424f266b"
  instance_type          = "t3a.small"
  ebs_optimized          = true
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.pritunl_vpn_access_sg.id]
  subnet_id              = module.vpc.public_subnets[1]
#   user_data
  iam_instance_profile        = aws_iam_instance_profile.vpn_pritunl.id
  associate_public_ip_address = true
  tags = {
    Name          = "vpn-${var.environment}",
    "Environment" = var.environment,
    "Terraform"   = true
  }
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 20
    }
  ]
}

# create an iam role for the vpn
resource "aws_iam_role" "vpn" {
  name = "vpn-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# attach the role to an instance profile
resource "aws_iam_instance_profile" "vpn" {
  name = "vpn-${var.environment}"
  role = aws_iam_role.vpn.id
}