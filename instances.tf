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
  provider   = aws.region-master
  key_name   = "jenkins"
  #public_key = file("~/.ssh/id_rsa.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRLTIuUEFLRj7+PbhWbuWEigBKBk7ej2XNQCEyyvsLCU5ja1OlnnMnzhiVptlIK29WQ2+UiWC/pd+reN7tcsu3XWf4iVOjfxavBPFfZw8P0Ywk0lfaQAvPIjfbBfdF2NDNOTjWL8vL/S8xz6pE9FVwmHnXrQePPTn5i54yotk7Am/Vf+edNzG/dnHuUTJRkiKKsy+akR+Zx7LuXi3m1bbCpuCGmlMowIX+Cjn4nQApycQla2qizKgj1/u6ViPc0cVBaVkSvWOdiQnTmThthIDEiCuBAcK+0rGtMnvwAfoJ8z+p2Lp0ajrPZU9YAKncTpKb/W245qNR9EAaHDderMB2++5lZHvbssEZOeWqeUstuAOvZv2Wdi+47bYZL5iYfUAiBWKricGAHGBHmtAausuwCiDfCjdkOu1CJI8oORH3KLjhWrR30y5eXs/mGQIqWlkBmGJvcHB+vvzlASD0IVfUbHI6Qs6Zdf/3foej8TLyBFEzQgYnBaQNoLNBgJ3uwjU= edward@fireside"
}
#Create key-pair for logging into EC2 in us-west-2
resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "jenkins"
  #public_key = file("~/.ssh/id_rsa.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRLTIuUEFLRj7+PbhWbuWEigBKBk7ej2XNQCEyyvsLCU5ja1OlnnMnzhiVptlIK29WQ2+UiWC/pd+reN7tcsu3XWf4iVOjfxavBPFfZw8P0Ywk0lfaQAvPIjfbBfdF2NDNOTjWL8vL/S8xz6pE9FVwmHnXrQePPTn5i54yotk7Am/Vf+edNzG/dnHuUTJRkiKKsy+akR+Zx7LuXi3m1bbCpuCGmlMowIX+Cjn4nQApycQla2qizKgj1/u6ViPc0cVBaVkSvWOdiQnTmThthIDEiCuBAcK+0rGtMnvwAfoJ8z+p2Lp0ajrPZU9YAKncTpKb/W245qNR9EAaHDderMB2++5lZHvbssEZOeWqeUstuAOvZv2Wdi+47bYZL5iYfUAiBWKricGAHGBHmtAausuwCiDfCjdkOu1CJI8oORH3KLjhWrR30y5eXs/mGQIqWlkBmGJvcHB+vvzlASD0IVfUbHI6Qs6Zdf/3foej8TLyBFEzQgYnBaQNoLNBgJ3uwjU= edward@fireside"
}
