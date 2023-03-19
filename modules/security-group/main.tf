# Create Security Group for the Application Load Balancer
# terraform aws create security group
resource "aws_security_group" "alb-security-group" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http traffic"
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https traffic"
    from_port        = "443"
    to_port          ="443"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "alb security group"
  }
}

# Create Security Group for the Bastion Host aka Jump Box
# terraform aws create security group
resource "aws_security_group" "jenkins-security-group" {
  name        = "jenkins security group"
  description = "allow ssh and jenkins inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Jenkins traffic"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Jenkins security group"
  }
}

# Create Security Group for the Web Server
# terraform aws create security group
resource "aws_security_group" "ecs-security-group" {
  name        = "ecs security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id
  ingress {
    description      = "http traffic"
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb-security-group.id]
  }

  ingress {
    description      = "https traffic"
    from_port        = "443"
    to_port          = "443"
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb-security-group.id]
  }

    ingress {
    description      = "ssh traffic"
    from_port        = "22"
    to_port          = "22"
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb-security-group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ecs security group"
  }
}

# Create Security Group for the Database
# terraform aws create security group
 resource "aws_security_group" "k8s_security_group" {
  name        = "k8s security group"
  description = "All access for k8s port"
  vpc_id      = var.vpc_id

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 9796
    to_port          = 9796
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 8090
    to_port          = 8091
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 6783
    to_port          = 6783
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 6783
    to_port          = 6784
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 4789
    to_port          = 4789
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 8472
    to_port          = 8472
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 9099
    to_port          = 9099
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 8285
    to_port          = 8285
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 2376
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 10250
    to_port          = 10254
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "k8s traffic access to all ports"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = - 1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "k8s Instances security group"
  }
}