provider "aws" {
region = "us-east-1"
shared_credentials_file = "C:/Users/sarthak/.aws/credentials"
}

resource "aws_instance" "os1" {
ami = "ami-0d5eff06f840b45e9"
instance_type = "t2.micro"

tags = {
	Name = "launched using tf"
	}
}


resource "aws_ebs_volume" "st1" {
	availability_zone = aws_instance.os1.availability_zone 
	size = 10 
	tags = {
	Name = "disk"
	}
}

resource "aws_volume_attachment" "ebs_att" {
	device_name = "/dev/sdh"
	volume_id = aws_ebs_volume.st1.id
	instance_id = aws_instance.os1.id
}


output "op1"{
	value = aws_instance.os1
}


output "op2"{
	value = aws_ebs_volume.st1
}

output "op3"{
	value = aws_volume_attachment.ebs_att
}
