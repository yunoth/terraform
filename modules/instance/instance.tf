resource "aws_instance" "web" {
  ami           = "ami-06d0f49becb35d6b1"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.sg}"]

  tags = {
    Name = "${var.name}"
  }
}