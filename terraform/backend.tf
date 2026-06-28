# Uncomment and configure this backend block after creating your S3 state bucket
#
# First-time setup:
# 1. Run: terraform init
# 2. Apply the configuration: terraform apply (creates S3 bucket and CloudFront)
# 3. Create an S3 bucket manually for Terraform state (e.g., via AWS Console or CLI)
# 4. Uncomment the backend block below
# 5. Run: terraform init -migrate-state
#    This will prompt you to copy existing state to the new backend
#
# terraform {
#   backend "s3" {
#     bucket         = "gauravkarkidmi-terraform-state"
#     key            = "portfolio/terraform.tfstate"
#     region         = "eu-north-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
