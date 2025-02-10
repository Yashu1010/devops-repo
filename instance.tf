provider "aws" {
    region = "us-east-1"
    
}



resource "aws_instance" "myec2" {
    ami = "ami-04b4f1a9cf54c11d0"
    key_name = "yash-key.pem"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.pub_sub.id
    tags = {
        Name = "practice instancegit"
    }
}