#This data object is going to be holding the vpc in aws
variable "vpc" {}
data "aws_vpc" "vpc" {
  id = var.vpc
}

variable "subnets" {
  type = map(any)

  default = {
    public-subnet = {
      "name"              = "public-subnet"
      "availability_zone" = "us-west-2a"
      "cidr_block"        = "10.0.1.0/24"
    }

    private-subnet-1 = {
      "name"              = "private-subnet-1"
      "availability_zone" = "us-west-2b"
      "cidr_block"        = "10.0.2.0/24"
    }

    private-subnet-2 = {
      "name"              = "private-subnet-2"
      "availability_zone" = "us-west-2c"
      "cidr_block"        = "10.0.3.0/24"
    }
  }
}

