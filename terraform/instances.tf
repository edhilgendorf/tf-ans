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

data "template_file" "user_data" {
  template = file("./scripts/cloud-init.yaml")
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider = aws.region-master
  key_name = "devops"
  public_key = file("ssh/id_rsa.pub")
}
#Create key-pair for logging into EC2 in us-west-2
resource "aws_key_pair" "worker-key" {
  provider = aws.region-worker
  key_name = "devops"
  public_key = file("ssh/id_rsa.pub")
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "devops-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.devops-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  tags = {
    Name = "devops_master_tf"
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}
#Create EC2 in us-west-2
resource "aws_instance" "devops-worker-oregon" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAmiOregon.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.devops-sg-oregon.id]
  subnet_id                   = aws_subnet.subnet_1_oregon.id
  tags = {
    Name = join("_", ["devops_worker_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.devops-master]
}
