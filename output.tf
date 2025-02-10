output "aws_instance" {
    value = aws_instance.myec2.public_ip
}

output "aws_vpc" {
    value = aws_vpc.myvpc.id 
}