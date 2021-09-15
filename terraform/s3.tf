resource "aws_s3_bucket" "misc-data" {
  provider  = aws.region-master
  bucket    = "hilgendorf-misc-data"
  acl       = "private"

  tags = {
    Name        = "misc data"
  }
}
