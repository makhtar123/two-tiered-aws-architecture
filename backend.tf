terraform {
  backend "s3" {
    bucket       = "demo-terraform-state-makhtar"
    key          = "webapp/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}
