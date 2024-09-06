resource "aws_kms_key" "backend" {
  description             = "Terraform backend bucket kms-key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "bucket" {
  name          = "alias/terraform-backend-bucket-key"
  target_key_id = aws_kms_key.backend.key_id
}

output "kms_key_id" {
  value = aws_kms_key.backend.id
}
