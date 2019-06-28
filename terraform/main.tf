data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name   = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

# Create the instance
module "ec2_instance" {
  source        = "./modules/instance"
  name          = "Instance"
  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.micro"
  count         = 1

  vpc_security_group_ids = [
    "${module.security_group.security_group_id}"
  ]
}

# Create the sg
module "security_group" {
  source      = "./modules/security_group"
  name        = "web"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "Allow Http"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "http-80-tcp",
    "https-443-tcp",
    "all-icmp"
  ]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "${var.ssh_range}"
    }
  ]

  egress_rules = ["all-all"]
}
