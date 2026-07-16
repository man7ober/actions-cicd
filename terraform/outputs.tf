output "security_group_id" {
  value = aws_security_group.my_sg.id
}

output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}
