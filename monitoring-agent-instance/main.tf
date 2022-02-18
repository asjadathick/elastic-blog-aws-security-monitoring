provider "aws" {
  region = "us-east-1"
}

provider "random" {}

resource "random_pet" "cloud_security_monitor" {}

resource "aws_security_group" "cloud_security_monitor-sg" {
  name = "${random_pet.cloud_security_monitor.id}-sg"
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "cloud_security_monitor_instance" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.cloud_security_monitor-sg.id]

  tags = {
    Name = random_pet.cloud_security_monitor.id
  }
}
