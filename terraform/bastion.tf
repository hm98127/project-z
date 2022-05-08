# Key Pair create 
resource "aws_key_pair" "loljoa2-key" {
  key_name = "loljoa2-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# Elastic IP - Bastion host 
resource "aws_eip" "loljoa2-bastion-eip" {
  vpc = true

  instance            = aws_instance.loljoa2-bastion.id
  depends_on          = [aws_internet_gateway.loljoa2-igw]
  tags = {
    "Name" = "loljoa2-bastion-eip"
  }
}

# Bastion host EC2 create
resource "aws_instance" "loljoa2-bastion" {
  ami                     = "ami-033a6a056910d1137"
  instance_type           = "t2.small"
  subnet_id               = aws_subnet.loljoa2-pub-sub.id
  vpc_security_group_ids  = [aws_security_group.loljoa2-bastion-sg.id]
  key_name                = aws_key_pair.loljoa2-key.key_name 

  associate_public_ip_address = true
  
  root_block_device {
    delete_on_termination =  false
    volume_size = 50
  }

  tags = {
    Name = "loljoa2-bastion"
  }
}

# Elastic IP - Jenkins host
resource "aws_eip" "loljoa2-jenkins-eip" {
  vpc = true

  instance            = aws_instance.loljoa2-jenkins.id
  depends_on          = [aws_internet_gateway.loljoa2-igw]
  tags = {
    "Name" = "loljoa2-jenkins-eip"
  }
}

# Bastion host EC2 create
resource "aws_instance" "loljoa2-jenkins" {
  ami                     = "ami-0454bb2fefc7de534"
  instance_type           = "t2.small"
  subnet_id               = aws_subnet.loljoa2-pub-sub.id
  vpc_security_group_ids  = [aws_security_group.loljoa2-bastion-sg.id]
  key_name                = aws_key_pair.loljoa2-key.key_name

  associate_public_ip_address = true

  root_block_device {
    delete_on_termination =  false
    volume_size = 30
  }

  tags = {
    Name = "loljoa2-jenkins"
  }
}
