
# File: ec2.tf

resource "aws_instance" "primepath_web" {
  ami                         = "ami-0b86aaed8ef90e45f" # This AMI value is unique per region (US-EAST-2). Ensure to use the AMI ID for the region you are deploying to.
  instance_type               = "t2.micro"
  key_name                    = "Patty--"
  subnet_id                   = aws_subnet.primepath_project_public_subnet-az1a.id
  vpc_security_group_ids      = [aws_security_group.primepath_web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install -y httpd
    cd /var/www/html
    wget https://github.com/hifyndubuisi/jupiter-zip-file/raw/main/jupiter-main.zip 
    unzip jupiter-main.zip
    cp -r jupiter-main/* /var/www/html
    rm -rf jupiter-main jupiter-main.zip
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = "Primepath Web Server"
  }
}

