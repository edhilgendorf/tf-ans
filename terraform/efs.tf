resource "aws_efs_file_system" "dev" {
  creation_token = "dev-volume"

  tags = {
    Name = "keys"
  }
}
