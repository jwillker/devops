resource "aws_instance" "instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  user_data     = "${var.user_data}"
  count         = "${var.count}"
  key_name      = "${var.key_name}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  tags = "${map("Name", "${var.name}")}"

  lifecycle {
    create_before_destroy = true
  }
}
