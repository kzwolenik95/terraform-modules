module "dev_vpc" {
  source         = "../.."
  
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "demo-vpc"

  tags = {
    "Environment" = "dev"
    "Project"     = "demo-project"
  }

  public_subnets = [
    "10.0.1.0/24"
  ]

  private_subnets = [
    "10.0.3.0/24"
  ]

  azs = [
    "us-east-1a"
  ]

  use_nat_gateway = false
}
