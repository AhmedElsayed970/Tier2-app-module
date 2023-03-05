# create a security group for the RDS instance 
# called securitygroup2 

resource "aws_security_group" "securitygroup2" {
  name        = "ahmed-security-group2"
  description = "Security group to allow RDS traffic"

  vpc_id = data.aws_vpc.vpc.id

  # create an inbound rule that allows traffic from the EC2 security group
  # through TCP port 3306, which is the port that MYSQL communicates through

  ingress {
    description = "Allow MYSQL traffic from only the web security group"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }


  #  allow all outbound traffic from the ec2 instance
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_RDS"
  }
}

resource "aws_db_subnet_group" "sub-group" {
  name       = "ahmed-sub-group"
  subnet_ids = [aws_subnet.create-subnet["private-subnet-1"].id, aws_subnet.create-subnet["private-subnet-2"].id]

  tags = {
    Name = "ahmed-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "ahmed-database"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "ahmed"
  password             = "12345"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "ahmed-sub-group"
  multi_az             = true

  port                   = 3306
  vpc_security_group_ids = [aws_security_group.securitygroup2.id]
}
