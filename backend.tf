terraform {
  backend "s3" {
    profile        = "eks"
    bucket         = "eks-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks_terraform"
  }
}
