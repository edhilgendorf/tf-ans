resource "aws_ecr_repository" "images" {
  name                 = "docker_images"
  image_tag_mutability = "MUTABLE"
  region = var.region-master

  image_scanning_configuration {
    scan_on_push = true
  }
}
