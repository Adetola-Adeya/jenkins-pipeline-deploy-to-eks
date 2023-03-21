terraform {
  backend "s3" {
    bucket = "my12buckettola3"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
