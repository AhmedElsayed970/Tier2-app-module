#  Create a security group that allow http, https traffic to get into the instance
resource "aws_security_group" "securitygroup1" {
  name        = "ahmed-security-group1"
  description = "Allow all inbound traffic througth HTTP and HTTPS"

  vpc_id = data.aws_vpc.vpc.id


  # create an inbound rule that allows all traffic through
  # Tcp port 443
  ingress {
    description = "HTTPS "
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  # create an inbound rule that allows all traffic through
  # Tcp port 80  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  # This outbound rule is allowing all outbound traffic
  # with the EC2 instances
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_https"
  }
}



# creating an EC2 instance within a tag name

resource "aws_instance" "my-instance" {
  ami           = "ami-0b029b1931b347543"
  instance_type = "t2.micro"


  vpc_security_group_ids = [aws_security_group.securitygroup1.id]

  subnet_id = aws_subnet.create-subnet["public-subnet"].id

  # This is my key pair that used to authentication when access this instance by ssh
  key_name = "ahmed-key"

  # This is the the instance name 
  tags = {
    Name = "ahmed-ec2"
  }
}

# Generate an EIp elastic public ip 
resource "aws_eip" "my-eip" {
  instance = aws_instance.my-instance.id
  vpc      = true

}

# Its define how to upload "terraform.tfstate" file to S3 
terraform {
  backend "s3" {
    bucket = "ahmed-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
