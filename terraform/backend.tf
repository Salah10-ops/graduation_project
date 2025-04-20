terraform {
  backend "s3" {
    bucket         = "devops-project-tfstate-salah-2025"
    key            = "devops/graduation_project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}