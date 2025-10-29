terraform {
  backend "s3" {
    bucket         = "tfstate-edward-mlops"       # <-- ОНОВЛЕНА НАЗВА
    key            = "vpc/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
