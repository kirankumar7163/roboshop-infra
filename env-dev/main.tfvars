env = "dev"
default_vpc_id = "vpc-04018a37c2a1f4629"

vpc ={
  main = {
    cidr_block = "10.0.0.0/16"
  }
}

subnets ={
  public ={
    cidr_block = ["10.0.0.0/24", "10.0.1.0/24"]
    availability_zone = ["us-east-1a", "us-east-1b"]
    name = "public"
    vpc_name = "main"

  }
  web ={

  }
  db = {

  }
}