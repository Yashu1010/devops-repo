resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
tags = {
  Name = "myvpc"
  env = "dev"
}
}

resource "aws_subnet" "pub_sub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/20"
    map_public_ip_on_launch = true
  tags = {
  Name = "my_sub"
  env = "dev"
}
}

resource "aws_subnet" "pvt_sub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/20"
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
        cidr_block = "10.0.1.0/24"
        gateway_id = aws_internet_gateway.my_igw.id
    }
  
}

resource "aws_route_table_association" "route_subnet" {
    subnet_id = aws_subnet.pub_sub.id
    route_table_id = aws_route_table.my_route.id
  
}