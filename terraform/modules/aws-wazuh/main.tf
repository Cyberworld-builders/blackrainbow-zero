resource "aws_eip" "wazuh" {}

resource "aws_instance" "wazuh" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.wazuh.id]
  subnet_id     = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.wazuh.name

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    eip        = aws_eip.wazuh.public_ip
  })
  
  tags = {
    Name = "${var.project_name}-${var.environment}-wazuh"
  }  
}

resource "aws_eip_association" "wazuh" {
  instance_id   = aws_instance.wazuh.id
  allocation_id = aws_eip.wazuh.id
}

# Security Group and Rules
resource "aws_security_group" "wazuh" {
  name        = "${var.project_name}-${var.environment}-wazuh"
  description = "Security group for wazuh SIEM"
  vpc_id      = var.vpc_id  
}

# ingress on ephemeral ports
resource "aws_security_group_rule" "wazuh-ephemeral" {
    type              = "ingress"
    from_port         = 32768
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.wazuh.id
}

# This could be better. Instead of having a list of IPs, we could maybe use a proxy where
# we can whitelist the SecOps team. I would like it to be based on security group or subnet, not a list of IPs.
# resource "aws_security_group_rule" "wazuh-https" {
#     type              = "ingress"
#     from_port         = 443
#     to_port           = 443
#     protocol          = "tcp"
#     cidr_blocks       = var.allowed_ips
#     security_group_id = aws_security_group.wazuh.id
# }

# Loop through the list of IPs and create a rule for each one
resource "aws_security_group_rule" "wazuh-https" {
  count             = length(var.allowed_ips)
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ips[count.index]]
  security_group_id = aws_security_group.wazuh.id
}

resource "aws_security_group_rule" "wazuh-egress" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.wazuh.id
}

# instance profile
resource "aws_iam_instance_profile" "wazuh" {
  name = "${var.project_name}-${var.environment}-wazuh"
  role = aws_iam_role.wazuh.name
}

# role
resource "aws_iam_role" "wazuh" {
  name = "${var.project_name}-${var.environment}-wazuh"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# role policy
resource "aws_iam_role_policy" "wazuh" {
  name = "wazuh"
  role = aws_iam_role.wazuh.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSnapshotAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeTags",
        "ec2:DescribeAddresses",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeNetworkInterfaceAttribute",
        "ec2:DescribeNetworkInterfacePermissions",
        "ec2:DescribeRouteTables",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeVpcEndpointAttribute",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeVpnGateways",
        "ec2:DescribeVpnConnections"
        ],
        "Effect": "Allow",
        "Resource": "*"
    }
    ]
}
EOF
}
