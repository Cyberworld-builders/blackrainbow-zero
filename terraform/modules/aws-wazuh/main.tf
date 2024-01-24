# instance profile
resource "aws_iam_instance_profile" "wazuh" {
  name = "${var.project_name}-${var.environment}-wazuh"
  role = aws_iam_role.wazuh.name
}

# Security Group and Rules
resource "aws_security_group" "wazuh" {
  name        = "${var.project_name}-${var.environment}-wazuh"
  description = "Security group for wazuh SIEM"
  vpc_id      = var.vpc_id  
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
