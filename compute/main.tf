# resource "aws_key_pair" "my-key" {
#   key_name   = "my-key"
#   public_key = var.public_ssh_key
# }

resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.generated.public_key_openssh # -> authorized_keys
}

resource "aws_security_group" "ec2-sg" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = var.owner
  }
}

resource "aws_instance" "public-ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  tags = {
    Name  = "${var.instance_name}-public"
    Owner = var.owner
  }
}

resource "aws_instance" "private-ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  tags = {
    Name  = "${var.instance_name}-private"
    Owner = var.owner
  }
}
