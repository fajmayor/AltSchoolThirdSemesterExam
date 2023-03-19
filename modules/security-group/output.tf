output "alb_security_group_id" {
  value = aws_security_group.alb-security-group.id
}
  
output "ecs_security_group_id" {
  value = aws_security_group.ecs-security-group.id
}

output "jenkins_security_group_id" {
  value = aws_security_group.jenkins-security-group.id
}

output "k8s_security_group_id" {
  value = aws_security_group.k8s_security_group.id
}

