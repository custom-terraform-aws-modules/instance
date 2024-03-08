################################
# IAM Role                     #
################################

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "main" {
  name               = "${var.identifier}-ServiceRoleForEC2"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "import" {
  count      = length(var.policies)
  role       = aws_iam_role.main.name
  policy_arn = var.policies[count.index]
}

################################
# SSH Tunnel                   #
################################

resource "aws_key_pair" "main" {
  key_name   = "${var.identifier}-ec2"
  public_key = var.public_key

  tags = var.tags
}

resource "aws_security_group" "ssh" {
  name        = "${var.identifier}-ec2-ssh"
  description = "Allow SSH tunnel connection to EC2 instance."
  vpc_id      = var.vpc

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

################################
# EC2 Instance                 #
################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-03484a09b43a06725"]
  }
}

resource "aws_iam_instance_profile" "main" {
  name = var.identifier
  role = aws_iam_role.main.name

  tags = var.tags
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.main.id
  iam_instance_profile        = aws_iam_instance_profile.main.name
  subnet_id                   = var.subnet
  vpc_security_group_ids      = concat(var.security_groups, [aws_security_group.ssh.id])

  tags = var.tags
}
