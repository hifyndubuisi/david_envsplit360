# create application load balancer
# terraform aws create application load balancer

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]

  # ensure the ALB lives in your public subnets
  subnet_mapping {
    subnet_id = aws_subnet.primepath_project_public_subnet-az1a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.primepath_project_public_subnet-az1b.id
  }


  enable_deletion_protection = false

  tags = {
    Name        = "application_loadbalancer_primepath"
    Environment = "production"
  }
}

# Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "primepath-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.primepath_project_vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Register the primepath web server with the target group
resource "aws_lb_target_group_attachment" "primepath_web_target_group_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.primepath_web.id
  port             = 80
}

# HTTP → HTTPS redirect listener
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener forwarding to target group
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
