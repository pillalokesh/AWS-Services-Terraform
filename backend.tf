terraform {
  backend "s3" {
    bucket  = "tarraform-lokesh-services01"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
