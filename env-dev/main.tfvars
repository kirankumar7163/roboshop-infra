env = "dev"
default_vpc_id = "vpc-04018a37c2a1f4629"

vpc ={
  main = {
    cidr_block = "10.0.0.0/16"
    availability_zone = ["us-east-1a", "us-east-1b"]
    private_subnets = {
      web = {
        cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
        name       = "web"
        nat_gw     = true
      }

      db = {
        cidr_block = ["10.0.4.0/24", "10.0.5.0/24"]
        name       = "db"
        nat_gw     = true
      }

      app = {
        cidr_block = ["10.0.6.0/24", "10.0.7.0/24"]
        name       = "app"
        nat_gw     = true
      }
    }

    public_subnets = {
      public = {
        cidr_block  = ["10.0.0.0/24", "10.0.1.0/24"]
        name        = "public"
        internet_gw = true
      }
    }
  }
}

docdb = {
  main = {
    vpc_name     = "main"
    subnets_name = "db"
    engine_version = "4.0.0"
    number_of_instances = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main = {
    vpc_name            = "main"
    subnets_name        = "db"
    engine              = "aurora-mysql"
    engine_version      = "5.7.mysql_aurora.2.03.2"
    number_of_instances = 1
    instance_class      = "db.t3.small"
  }
}

elasticache = {
  main = {
    vpc_name            = "main"
    subnets_name        = "db"
    engine              = "redis"
    replicas_per_node_group = 1
    num_node_groups         = 2
    node_type           = "cache.t3.micro"
  }
}


rabbitmq = {
  main = {
    vpc_name            = "main"
    subnets_name        = "db"
    engine_type         = "RabbitMQ"
    engine_version      = "3.10.10"
    host_instance_type = "m3.t3.micro"
  }
}