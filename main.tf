resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  region        = var.region-master


  tags = {
    Name = "ExampleAppServerInstance"
  }
}
