terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "devop-repo"
    key = "terraform.tfstate"
  }
}

provider "aws" {
    region = var.region   
}
resource "aws_instance" "myec2" {
    ami = "ami-04b4f1a9cf54c11d0"
    key_name = "yash-key"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ data.aws_security_groups.mysg.id ]
    subnet_id = aws_subnet.pub_sub.id
    tags = {
        Name = "practice_instance"
    }
}
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
tags = {
  Name = "myvpc"
  env = "dev"
}
}

resource "aws_subnet" "pub_sub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
  tags = {
  Name = "my_sub"
  env = "dev"
}
}

resource "aws_subnet" "pvt_sub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false
    tags = {
  Name = "my_pvt_sub"
  env = "dev"
}
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.myvpc.id
  
}

resource "aws_route_table" "my_route" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
  
}

resource "aws_route_table_association" "route_subnet" {
    subnet_id = aws_subnet.pub_sub.id
    route_table_id = aws_route_table.my_route.id
  
}

data "aws_security_groups" "mysg" {


    filter {
      name = "group-name"
      values = [ "mysg" ]
    }
}