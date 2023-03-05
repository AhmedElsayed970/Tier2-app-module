
resource "aws_subnet" "create-subnet" {
  for_each = var.subnets
  vpc_id   = data.aws_vpc.vpc.id

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

}


# create an internet gateway named "inter-gateway"
# and attach it to the VPC
resource "aws_internet_gateway" "inter-gateway" {
  # we are attaching the internet gateway to the VPC
  vpc_id = data.aws_vpc.vpc.id

  # we are tagging the internet gateway with the name "ahmed-gateway"
  tags = {
    Name = "ahmed-gateway"
  }
}

# create a public route named "public-route"
resource "aws_route_table" "public-route" {
  #put the route table in the "vpc" VPC
  vpc_id = data.aws_vpc.vpc.id

  # This is the public route table, it will need access to the internet.
  # we are adding a route with a destination of 0.0.0.0/0 and targeting 
  # the internet gateway "inter-gateway"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inter-gateway.id
  }

  tags = {
    Name = "ahmed-public-route"
  }
}


# we add the public subnets to the public route table 
resource "aws_route_table_association" "route-associate" {
  # This is the subnet id  
  subnet_id      = aws_subnet.create-subnet["public-subnet"].id
  route_table_id = aws_route_table.public-route.id
}
