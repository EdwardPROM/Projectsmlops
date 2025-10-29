terraform {
  # Configure remote state backend via CLI flags at init time.
  # Example:
  # terraform init \
  #   -backend-config="bucket=<your-bucket>" \
  #   -backend-config="key=vpc/terraform.tfstate" \
  #   -backend-config="region=<aws-region>" \
  #   -backend-config="dynamodb_table=<lock-table>" \
  #   -backend-config="encrypt=true"
  backend "s3" {}
}

