env = "dev"
default_vpc_id = "vpc-0b7d7daeedf05b074"

vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    public_subnets_cidr = ["10.0.0.0/17", "10.0.1.0/17"]
    private_subnets_cidr = ["10.0.3.0/17", "10.0.4.0/17"]


  }
}