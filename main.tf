provider "aws" {
    region      = "${var.aws_region}"
    access_key  = "${var.aws_access_key}"
    secret_key  = "${var.aws_secret_key}"
}

### VPC Configuration

resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"

    tags {
        Name = "${var.vpc_name}"
    }
}

### Subnet configuration

resource "aws_subnet" "subnet_main" {
    vpc_id      = "${aws_vpc.main.id}"
    cidr_block  = "${var.subnet_cidr}"

    tags {
        Name = "${var.subnet_name}"
    }
}

### SSH KEY

resource "aws_key_pair" "ssh_key" {
    key_name    = "${var.key_name}"
    public_key  =  ""
}

### Security group

resource "aws_security_group" "sg_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}

### Instance definition

resource "aws_instance" "this_t2" {
  count = "${var.instance_count}"

  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.subnet_main.id}"
  key_name               = "${var.key_name}"
  security_groups        = "${aws_security_group.sg_all.id}"

  associate_public_ip_address = "true"

  ebs_optimized          = "true"

}  
 