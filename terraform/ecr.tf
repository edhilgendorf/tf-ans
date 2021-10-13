provider "aws" {
  region = var.region-worker

}
resource "aws_ecr_repository" "images" {
  name                 = "docker_images"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
