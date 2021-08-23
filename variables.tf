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

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}
