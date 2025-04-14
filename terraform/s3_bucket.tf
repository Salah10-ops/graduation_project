resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "devops-project-tfstate-salah-2025"  
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "dev"
  }
}