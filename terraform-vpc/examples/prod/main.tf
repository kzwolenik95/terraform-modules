module "prod_vpc" {
  source = "../.."

  vpc_cidr_block = "10.1.0.0/16"
  vpc_name       = "demo-vpc"

  tags = {
    "Environment" = "prod"
    "Project"     = "demo-project"
  }

  public_subnets = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnets = [
    "10.1.3.0/24",
    "10.1.4.0/24"
  ]

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  use_nat_gateway = true
}
