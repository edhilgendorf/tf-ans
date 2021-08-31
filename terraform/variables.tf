variable "profile" {
  type    = string
  default = "tf_user"
}
variable "region-master" {
  type    = string
  default = "us-east-1"
}
variable "region-worker" {
  type    = string
  default = "us-west-2"
}
variable "test" {
  type    = string
  default = "catheadbiscuit"
}
#Replace with <YOUR_EXTERNAL_IP>  https://ipv4.icanhazip.com
variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}
variable "workers-count" {
  type    = number
  default = 1
}
variable "instance-type" {
  type    = string
  default = "t3.micro"
}
variable "ansible-git" {
  type    = string
  default = "https://github.com/edhilgendorf/ansible-cloud.git"
}
