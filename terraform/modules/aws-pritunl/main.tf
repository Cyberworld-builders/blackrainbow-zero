module "vpn_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "v5.1.0"
  name                   = "vpn-${var.environment}"
  ami                    = "ami-05fb0b8c1424f266b"
  instance_type          = "t3a.small"
  ebs_optimized          = true
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.pritunl_vpn_access_sg.id]
  subnet_id              = var.subnet_id
  user_data = templatefile("${path.module}/vpn-userdata.tpl", {
    environment = var.environment,
    prefix      = "vpn-${var.environment}"
  })
  iam_instance_profile        = aws_iam_instance_profile.vpn.id
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

# create a security group for the vpn
resource "aws_security_group" "pritunl_vpn_access_sg" {
  name        = "pritunl-vpn-access-sg-${var.environment}"
  description = "Security group for pritunl vpn access"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        Name          = "pritunl-vpn-access-sg-${var.environment}",
        "Environment" = var.environment,
        "Terraform"   = true
    }
}

# allow access to the vpn from the internet
resource "aws_security_group_rule" "pritunl_vpn_access_sg_ingress" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.pritunl_vpn_access_sg.id
}

# allow ingress on port 80 for letsencrypt
resource "aws_security_group_rule" "pritunl_vpn_access_sg_ingress_letsencrypt" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.pritunl_vpn_access_sg.id
}

# allow access to the vpn from the internet
resource "aws_security_group_rule" "pritunl_vpn_access_sg_ingress_udp" {
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.pritunl_vpn_access_sg.id
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

#  launch an eip
resource "aws_eip" "vpn" {}

# create an attachment with the instance
resource "aws_eip_association" "vpn" {
  instance_id   = module.vpn_instance.id
  allocation_id = aws_eip.vpn.id
}
