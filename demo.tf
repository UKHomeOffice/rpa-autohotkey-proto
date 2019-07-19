provider "aws" {
  region = "eu-west-2"
}

data "aws_ami" "packer_win_demo" {
  most_recent = true
  owners      = ["self"]

  filter {
    name = "name"

    values = [
      "autohotkey*",
    ]
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "rpademo"
  force_destroy = true
  acl           = "private"
  #TODO enable encryption
  #TODO enable object logging to cloudtrail
  tags = {
    Name = "rpademo"
  }
}

resource "aws_security_group" "rdpdemo" {
  name        = "rdpdemo"
  description = "rdpdemo"

  # RDP access from anywhere
  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  # WinRM access from anywhere
  ingress {
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows" {
  # wait_for_fulfillment                 = true
  # spot_type                            = "one-time"
  key_name                             = "demo"
  instance_type                        = "t2.medium"
  ami                                  = "${data.aws_ami.packer_win_demo.id}"
  instance_initiated_shutdown_behavior = "terminate"
  get_password_data                    = true
  security_groups = [
    "${aws_security_group.rdpdemo.name}",
  ]
  provisioner "remote-exec" {
    script = "./scripts/execute.ps1"
  }
  connection {
    type     = "winrm"
    user     = "Administrator"
    host     = self.public_ip
    https    = true
    insecure = true
    port     = 5986
    timeout  = "10m"
  }
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
}


data "aws_iam_policy_document" "policy_doc" {

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}"
    ]
  }
}

resource "aws_iam_instance_profile" "profile" {
  name = "rpa_demo"
  role = "${aws_iam_role.instance.name}"
}

resource "aws_iam_role_policy" "role_policy" {
  name = "rpa_demo"
  role = "${aws_iam_role.instance.id}"

  policy = "${data.aws_iam_policy_document.policy_doc.json}"

}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "rpa_demo"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

output "ec2_password" {
  value = "${rsadecrypt(aws_instance.windows.password_data, file("/Users/cns/Downloads/demo.pem"))}"
}
