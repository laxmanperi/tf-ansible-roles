# Security Group Ansible Master
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from Anywhere"
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
    Name = "Allow SSH"
  }
}
# Security Group Tomcat
resource "aws_security_group" "allow_Tomcat" {
  name        = "allow_Tomcat"
  description = "Allow Tomcat inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Tomcat from Anywhere"
    from_port   = 8080
    to_port     = 8080
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
    Name = "Tomcat"
  }
}
# Security Group Nexus
resource "aws_security_group" "allow_Nexus" {
  name        = "allow_Nexus"
  description = "Allow Nexus inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Nexus from Anywhere"
    from_port   = 8081
    to_port     = 8081
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
    Name = "Nexus"
  }
}

# Security Group Sonar
resource "aws_security_group" "allow_Sonar" {
  name        = "allow_Sonar"
  description = "Allow Sonar inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Sonar from Anywhere"
    from_port   = 9000
    to_port     = 9000
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
    Name = "Sonar"
  }
}



# Key Pair
resource "aws_key_pair" "my_WIN_key" {
  key_name   = "WIN-key"
  public_key = file(var.PATH_TO_PUB_KEY)
}

# Instance-Ansible Master
resource "aws_instance" "Ansible_Master" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.micro"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.81"

  # Select user_data
  user_data = file("install.sh")

  # Tag
  tags = {
    Name = "Ansible_Master"
  }

}

# Instance-Worker_Build
resource "aws_instance" "Worker_Build" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.micro"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.82"

  # Tag
  tags = {
    Name = "Worker_Build"
  }

}

# Instance-Worker_Sonar
resource "aws_instance" "Worker_Sonar" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.medium"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_Sonar.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.83"

  # Tag
  tags = {
    Name = "Worker_Sonar"
  }

}

# Instance-Worker_TCQA
resource "aws_instance" "Worker_TCQA" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.micro"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_Tomcat.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.84"

  # Tag
  tags = {
    Name = "Worker_TCQA"
  }

}

# Instance-Worker_Nexus
resource "aws_instance" "Worker_Nexus" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.medium"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_Nexus.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.85"

  # Tag
  tags = {
    Name = "Worker_Nexus"
  }

}

# Instance-Worker_TCProd
resource "aws_instance" "Worker_TCProd" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.micro"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_Tomcat.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.86"

  # Tag
  tags = {
    Name = "Worker_TCProd"
  }

}