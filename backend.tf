terraform {
  backend "s3" {
    bucket = "teraform-tutorial"
    key    = "resource/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-state"
  }
}