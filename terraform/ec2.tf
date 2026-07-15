# default vpc
resource "aws_default_vpc" "default_vpc" {}

# security group
resource "aws_security_group" "my_sg" {
  name   = "web-server-sg"
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    name = "WEB-SG"
  }
}

# ec2 instance
resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.default_ami.id
  key_name               = "my-key-pair"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[1]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pairs)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Connected to ${self.private_ip} | sudo tee /var/www/html/index.html"
    ]
  }

  tags = {
    name = "WEB-SERVER"
  }
}



