# terraform {
#   backend "s3" {
#     bucket         = "ckan-terraform-bucket-hml"
#     key            = "state/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     kms_key_id     = "alias/terraform-backend-bucket-key"
#     dynamodb_table = "terraform-backend-state-database"
#   }
# }
