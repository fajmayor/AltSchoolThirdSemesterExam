### ALTSCHOOL AFRICA THIRD SEMESTER EXAMINATION FOR CLOUD ENGINEER
This project is done with the use of Kubernetes, Terraform, Ansible and AWS Cloud provider.

#####1. Kubeadm Kubernetes Cluster:
I deployed all the infrastures required to provision/setup Kubeadm Nodes using terraform and ansible. 

The Secret files, terraform.tfvars files are encrypted using ANSIBLE VAULT. To view, edit or decrypt the encrypted files, use "Faith2020@" p@ssword.

The Master Node Controller Instance name on aws is KubeadmMasterNode
with "3.85.147.34" with 3 Worker Nodes.

The frontend of the sock-shop microservice deployed on this kubeadm cluster machine is: "3.85.147.34:30001"

The prometheus server: "3.85.147.34:31090" --- "sock-shop app specific"

The Grafana server: "3.85.147.34:31300" --- "sock-shop app specific"

The prometheus server: 3.85.147.34:30961/targets --- "Service/Resources monitoring"


######Challenge: I had issue setting up nginx ingress controller on the kubeadm cluster which made me to do more research on alternative Kubernetes cluster bootstrapping tools.

#####2. Kops Kubernetes Cluster:
Using Terraform, I deployed kops kubernetes clusters, 1 Master Node and 1 Worker to aws.

For the sock-shop microservice: sock.exam.fajmayor.me

For the webapp application with apache and mysql data, I deployed a ChatBox application for AltSchool: chatbox.exam.fajmayor.me

######Challenge: The LoadBalancer created for the monitoring and logging do not respond

