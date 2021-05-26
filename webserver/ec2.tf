provider "aws" {
	region = "us-east-1"
	shared_credentials_file = "C:/Users/sarthak/.aws/credentials"
}

resource "aws_instance" "webos1" {
ami = "ami-0d5eff06f840b45e9"
instance_type = "t2.micro"
security_groups = [ "webport-allow" ]
key_name = "terraform_key"
tags = {
	Name = "webserver using tf"
	}
}


resource "null_resource" "nullremote1" {

connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/sarthak/Downloads/terraform_key.pem")
    host     = aws_instance.webos1.public_ip
  }

provisioner "remote-exec" {
    inline = [
	"sudo yum install httpd -y",
	"sudo yum install php -y",
	"sudo systemctl start httpd",
	"sudo systemctl enable httpd"
    ]
  }

}



resource "aws_ebs_volume" "st1" {
	availability_zone = aws_instance.webos1.availability_zone 
	size = 10 
	tags = {
	Name = "disk using tf"
	}
}

resource "aws_volume_attachment" "ebs_att" {
	device_name = "/dev/sdh"
	volume_id = aws_ebs_volume.st1.id
	instance_id = aws_instance.webos1.id
}


resource "null_resource" "nullremote2" {
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/sarthak/Downloads/terraform_key.pem")
    host     = aws_instance.webos1.public_ip
  }

provisioner "remote-exec" {
    inline = [
"sudo mkfs.ext4 /dev/xvdh",
"sudo mount /dev/xvdh /var/www/html"
    ]
  }
}


resource "null_resource" "nullremote3" {

connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/sarthak/Downloads/terraform_key.pem")
    host     = aws_instance.webos1.public_ip
  }

provisioner "remote-exec" {
    inline = [
"sudo yum install git -y",
"sudo git clone https://github.com/sarthak-sriw/webserver_launch.git /var/www/html/"
    ]
  }


}

