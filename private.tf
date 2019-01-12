
##### private subnet ###########


resource "aws_eip" "ngeip" {
	vpc  = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ngeip.id}"
  subnet_id     = "${aws_subnet.websubnet1.id}"
}