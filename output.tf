# output ec2 public ip
# output "ec2_public_ip" {
#   value       = aws_instance.primepath_web.public_ip
#   description = "Public IP of the EC2 instance"
# }

output "alb_dns" {
  value = aws_lb.alb.dns_name
}
