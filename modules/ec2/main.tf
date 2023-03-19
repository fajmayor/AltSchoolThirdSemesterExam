# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_iam_role" "iam_role" {

  name = "EC2SSMRole"

}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

data "aws_availability_zones" "available_zones" {}

# launch the ec2 instance and install website
resource "aws_instance" "jenkins_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_az1_id
  vpc_security_group_ids = [var.jenkins_security_group_id, ]
  key_name               = "jenkins-keypair"
  iam_instance_profile = data.aws_iam_role.iam_role.name
  associate_public_ip_address = true
  #user_data = file("../modules/ec2/install_jenkins.sh")

  tags = {
    Name = "Jenkins-Instance"
  }
}

resource "aws_instance" "master_kubeadm_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.medium"
  subnet_id              = var.public_subnet_az1_id
  vpc_security_group_ids = [var.k8s_security_group_id, ]
  key_name               = "jenkins-keypair"
  iam_instance_profile = data.aws_iam_role.iam_role.name
  associate_public_ip_address = true

  tags = {
    Name = "KubeadmMasterNode"
  }
}

resource "aws_instance" "nodes_kubeadm_ec2_instance" {
  count                  = 2 
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.small"
  subnet_id              = var.public_subnet_az1_id
  vpc_security_group_ids = [var.k8s_security_group_id, ]
  key_name               = "jenkins-keypair"
  iam_instance_profile = data.aws_iam_role.iam_role.name
  associate_public_ip_address = true

  tags = {
    Name = "SlaveNode-Instance"
  }
}

/* resource "aws_instance" "new_nodes_kubeadm_ec2_instance" {
  count                  = 2 
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_az1_id
  vpc_security_group_ids = [var.k8s_security_group_id, ]
  key_name               = "jenkins-keypair"
  iam_instance_profile = data.aws_iam_role.iam_role.name
  associate_public_ip_address = true

  tags = {
    Name = "New-SlaveNode-Instance"
  }
} */

resource "aws_instance" "worker_new_kubeadm_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.small"
  subnet_id              = var.public_subnet_az2_id
  vpc_security_group_ids = [var.k8s_security_group_id, ]
  key_name               = "jenkins-keypair"
  iam_instance_profile = data.aws_iam_role.iam_role.name
  associate_public_ip_address = true

  tags = {
    Name = "Worker-New-SlaveNode-Instance"
  }
}

resource "local_file" "host_inventory" {
  content  = <<EOT
  [jenkins]
  %{for ip in aws_instance.jenkins_ec2_instance.*.public_ip[*] ~} 
  ${ip}
  %{endfor ~} 

  [master]
  %{for ip in aws_instance.master_kubeadm_ec2_instance.*.public_ip[*] ~} 
  ${ip}
  %{endfor ~}

  [workers]
  %{for ip in aws_instance.nodes_kubeadm_ec2_instance.*.public_ip[*] ~} 
  ${ip}
  %{endfor ~} 
  %{for ip in aws_instance.worker_new_kubeadm_ec2_instance.*.public_ip[*] ~} 
  ${ip}
  %{endfor ~} 

  [worker-new]
  %{for ip in aws_instance.worker_new_kubeadm_ec2_instance.*.public_ip[*] ~} 
  ${ip}
  %{endfor ~}
  EOT
  filename = "../ansible/inventories/dev/host-inventory"
}

