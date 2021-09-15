output "Devops-Main-Node-Public-IP" {
  value = aws_instance.devops-master.public_ip
}

output "Devops-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.devops-worker-oregon :
    instance.id => instance.public_ip
  }
}
