# search for terraform aws create a asg launch template
# terraform aws launch template
resource "aws_launch_template" "webserver_launch_template" {
  name          = "webserver-launch-template"
  image_id      = var.ec2_ami_id
  instance_type = "t2.micro"
  key_name      = "Patty--"
  description   = "launch template on asg"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.primepath_web_sg.id]

  user_data = base64encode(<<-EOF
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
  )
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity  = 2
  max_size          = 4
  min_size          = 1
  name              = "dev-asg"
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.webserver_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [
    aws_subnet.primepath_project_public_subnet-az1a.id,
    aws_subnet.primepath_project_public_subnet-az1b.id,
  ]

  tag {
    key                 = "Name"
    value               = "asg-webserver"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn
}


