resource "aws_s3_bucket" "misc-data" {
  bucket = "hilgendorf-misc-data"
  acl    = "private"

  tags = {
    Name        = "misc data"
  }
}
