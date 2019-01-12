provider "aws" {
  region     = "${var.region}"
  #access_key = "${var.access_key}"
  #secret_key = "${var.secret_key}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "training_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "training_igw"
  }
}

##### public subnet ########

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.main.id}"

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "public_route"
  }
  
}

resource "aws_subnet" "websubnet1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.websubnet1_cidr}"
    availability_zone = "${var.region}a"

  tags = {
    Name = "training_websubnet1"
  } 
}

resource "aws_route_table_association" "public_association1" {
  subnet_id      = "${aws_subnet.websubnet1.id}"
  route_table_id = "${aws_route_table.public_route.id}"  
}

resource "aws_subnet" "websubnet2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.websubnet2_cidr}"
    availability_zone = "${var.region}b"

  tags = {
    Name = "training_websubnet2"
  } 
}

resource "aws_route_table_association" "public_association2" {
  subnet_id      = "${aws_subnet.websubnet2.id}"
  route_table_id = "${aws_route_table.public_route.id}"  
}


resource "aws_route_table" "private_route" {
  vpc_id = "${aws_vpc.main.id}"

 route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = {
    Name = "private_route"
  }
  
}

module "appsubnet1" {
  source = "./modules/subnet"
  appsubnet1_cidr_block = "${var.appsubnet1_cidr_block}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.region}a"
  route_table_id = "${aws_route_table.private_route.id}"
  Name = "training_appsubnet1"
}

module "appsubnet2" {
  source = "./modules/subnet"
  appsubnet1_cidr_block = "${var.appsubnet2_cidr_block}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.region}b"
  route_table_id = "${aws_route_table.private_route.id}"
  Name = "training_appsubnet2"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}


module "appserver1" {
  source = "./modules/instance"
  subnet_id = "${module.appsubnet1.id}"
  sg = "${aws_security_group.allow_all.id}"
  name = "appserver1"
}