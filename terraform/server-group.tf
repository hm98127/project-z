# Security Group

# 1. Bastion host
resource "aws_security_group" "loljoa2-bastion-sg" {
  vpc_id  = aws_vpc.loljoa2-vpc.id
  name    = "loljoa2-bastion-sg"
  
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "jenkins"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "loljoa2-bastion-sg"
  }
}

# 2. EKS
resource "aws_security_group" "loljoa2-eks-sg" {
  name        = "loljoa2-eks-sg"
  vpc_id      = aws_vpc.loljoa2-vpc.id
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "loljoa2-eks-sg"
  }
}

resource "aws_security_group_rule" "loljoa2-eks-cluster-ingress" {
  cidr_blocks       = [aws_vpc.loljoa2-vpc.cidr_block]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.loljoa2-eks-sg.id
  to_port           = 443
  type              = "ingress"
}

# 3. RDS 
resource "aws_security_group" "loljoa2-rds-sg" {
  name      = "loljoa2-rds-sg"
  vpc_id    = aws_vpc.loljoa2-vpc.id 

  ingress {
    description   = "Mysql"
    from_port     = 3306
    to_port       = 3306
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description   = "SSH"
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Autoscailing group 

# RDS Autoscailing create 


