# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "from-atlantis" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.kk_sec_grp.id]
  key_name = "kk-amazon"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name = "kk-amazon"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCnJtt6dQtZSzm4j2qFF683S1JF88MR/cKtMve6wEzppSar6m3DLaw6zKcH964GzZSf4ImE6GBCZCyq4SCGd+zeSVZgmM/BlJPD/5PbiCgj/qd5klxyLmITNevuhBZntAFUbrx38RQXsu7Evo1T3SAkHd6yIGsZunF8yYr+6qBG/uOsswSbu8W/rTlJM3nlblbhhw5NJwcw/LAgeik76foOJkfAalI4sLG/P+OoFrdzhJHCq+fINkKDG56nyM3Z6NQ5z+TsIu/Eto0Fc4t056+vAkYML8hlReGOf9OqhnMljJaFkoBJspDaqPPQmaLTj6aO2W2Re7+3mlBG1xqUgNR chris@PLPC009460"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "kk_sec_grp" {
  name        = "kk-sec-grp"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 /* ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = "${var.bastion_remote_access_cidr}"
  }*/

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



