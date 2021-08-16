provider "aws" {
  profile = var.profile
  region  = var.region-master
  shared_credentials_file = "~/.aws/credentials"
  alias   = "region-master"
}

provider "aws" {
  profile = var.profile
  region  = var.region-worker
  shared_credentials_file = "~/.aws/credentials"
  alias   = "region-worker"
}
