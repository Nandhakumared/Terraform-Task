provider "aws" {
  region = "ap-south-1"
}

#Adding VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
  
}

#Adding 3 different subnets at 3 different AZ
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/26"
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/26"
  availability_zone = "ap-south-1b"
}

resource "aws_subnet" "subnet3" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/26"
  availability_zone = "ap-south-1c"
}

resource "aws_security_group" "sg1" {
    name = "my-ec2-sg"
    description = "sg for my ec2"

    vpc_id = aws_vpc.my_vpc.id

    ingress { 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Creating 2 EC2 with 2 different Subnets
resource "aws_instance" "EC201" {
  ami = "ami-03f4878755434977f"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  #security_groups = [aws_security_group.sg1.name]
  tags = {
    Name = "TF-instance1"
  }
}

resource "aws_instance" "EC202" {
  ami = "ami-03f4878755434977f"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  #security_groups = [aws_security_group.sg1.name]
  tags = {
    Name = "TF-instance2"
  }
}