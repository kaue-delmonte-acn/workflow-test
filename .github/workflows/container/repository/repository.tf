resource "random_uuid" "container_repository" {}

resource "aws_ecr_repository" "container_repository" {
  name = "terraform-${random_uuid.container_repository.result}"
}

output "container_repository_url" {
  value = aws_ecr_repository.container_repository.repository_url
}
