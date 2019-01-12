
resource "aws_subnet" "private_subnet" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.appsubnet1_cidr_block}"
    availability_zone = "${var.availability_zone}"

  tags = {
    Name = "${var.Name}"
  } 
}

resource "aws_route_table_association" "private_association1" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${var.route_table_id}"  
}


output "id" {
  value = "${aws_subnet.private_subnet.id}"
}