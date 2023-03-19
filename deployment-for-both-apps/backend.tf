terraform {
  backend "s3" {
    bucket = "my12buckettola3"
    key    = "deployment/terraform.tfstate"
    region = "us-east-1"
  }
}
