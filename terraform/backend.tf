terraform {
  backend "s3" {
    bucket         = "raju-remote-state"
    key            = "opensearch-stack/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
