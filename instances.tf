#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
#Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAmiOregon" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider = aws.region-master
  key_name = "jenkins"
  #public_key = file("~/.ssh/id_rsa.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRLTIuUEFLRj7+PbhWbuWEigBKBk7ej2XNQCEyyvsLCU5ja1OlnnMnzhiVptlIK29WQ2+UiWC/pd+reN7tcsu3XWf4iVOjfxavBPFfZw8P0Ywk0lfaQAvPIjfbBfdF2NDNOTjWL8vL/S8xz6pE9FVwmHnXrQePPTn5i54yotk7Am/Vf+edNzG/dnHuUTJRkiKKsy+akR+Zx7LuXi3m1bbCpuCGmlMowIX+Cjn4nQApycQla2qizKgj1/u6ViPc0cVBaVkSvWOdiQnTmThthIDEiCuBAcK+0rGtMnvwAfoJ8z+p2Lp0ajrPZU9YAKncTpKb/W245qNR9EAaHDderMB2++5lZHvbssEZOeWqeUstuAOvZv2Wdi+47bYZL5iYfUAiBWKricGAHGBHmtAausuwCiDfCjdkOu1CJI8oORH3KLjhWrR30y5eXs/mGQIqWlkBmGJvcHB+vvzlASD0IVfUbHI6Qs6Zdf/3foej8TLyBFEzQgYnBaQNoLNBgJ3uwjU= edward@fireside"
}
#Create key-pair for logging into EC2 in us-west-2
resource "aws_key_pair" "worker-key" {
  provider = aws.region-worker
  key_name = "jenkins"
  #public_key = file("~/.ssh/id_rsa.pub")
  public_key = file("ssh/id_rsa.pub")
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRLTIuUEFLRj7+PbhWbuWEigBKBk7ej2XNQCEyyvsLCU5ja1OlnnMnzhiVptlIK29WQ2+UiWC/pd+reN7tcsu3XWf4iVOjfxavBPFfZw8P0Ywk0lfaQAvPIjfbBfdF2NDNOTjWL8vL/S8xz6pE9FVwmHnXrQePPTn5i54yotk7Am/Vf+edNzG/dnHuUTJRkiKKsy+akR+Zx7LuXi3m1bbCpuCGmlMowIX+Cjn4nQApycQla2qizKgj1/u6ViPc0cVBaVkSvWOdiQnTmThthIDEiCuBAcK+0rGtMnvwAfoJ8z+p2Lp0ajrPZU9YAKncTpKb/W245qNR9EAaHDderMB2++5lZHvbssEZOeWqeUstuAOvZv2Wdi+47bYZL5iYfUAiBWKricGAHGBHmtAausuwCiDfCjdkOu1CJI8oORH3KLjhWrR30y5eXs/mGQIqWlkBmGJvcHB+vvzlASD0IVfUbHI6Qs6Zdf/3foej8TLyBFEzQgYnBaQNoLNBgJ3uwjU= edward@fireside"
}

data "template_file" "user_data" {
  template = file("./scripts/cloud-init.yaml")
}
#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  user_data                   = data.template_file.user_data.rendered
  tags = {
    Name = "jenkins_master_tf"
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}
#Create EC2 in us-west-2
resource "aws_instance" "jenkins-worker-oregon" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAmiOregon.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-oregon.id]
  subnet_id                   = aws_subnet.subnet_1_oregon.id
  tags = {
    Name = join("_", ["jenkins_worker_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master]
}
