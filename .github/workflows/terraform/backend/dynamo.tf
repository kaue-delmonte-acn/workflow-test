resource "aws_dynamodb_table" "backend" {
  name           = "terraform-backend-state-database"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "dynamodb_table" {
  value = aws_dynamodb_table.backend.name
}
