terraform {
  backend "s3" {
    bucket         = "tfstate-edward-mlops"
    key            = "eks/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
