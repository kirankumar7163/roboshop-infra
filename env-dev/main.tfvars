env = "dev"
default_vpc_id = "vpc-04018a37c2a1f4629"

vpc ={
  main = {
    cidr_block = "10.0.0.0/16"
    availability_zone = ["us-east-1a", "us-east-1b"]
    subnets ={
      public_subnets = {
        public = {
          cidr_block  = ["10.0.0.0/24", "10.0.1.0/24"]
          name        = "public"
          internet_gw = true
        }
      }

      private_subnets = {
        web ={
          cidr_block         = ["10.0.2.0/24", "10.0.3.0/24"]
          name               = "web"
          nat_gw = true
        }

        db = {
          cidr_block         = ["10.0.4.0/24", "10.0.5.0/24"]
          name               = "db"
          nat_gw = true
        }

        app = {
          cidr_block         = ["10.0.6.0/24", "10.0.7.0/24"]
          name               = "app"
          nat_gw = true
        }
      }

    }
  }
}