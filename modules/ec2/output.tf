# print the ec2's public ipv4 address
output "public_ipv4_address" {
  value = aws_instance.jenkins_ec2_instance.public_ip
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins_ec2_instance.public_dns
}