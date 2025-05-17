variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
  description = "CIDR for public subnet in us-east-1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
  description = "CIDR for public subnet in us-east-1b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_app_subnet_az1_cidr" {
  description = "CIDR for private app subnet in us-east-1a"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_app_subnet_az2_cidr" {
  description = "CIDR for private app subnet in us-east-1b"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_db_subnet_az1_cidr" {
  description = "CIDR for private DB subnet in us-east-1a"
  type        = string
  default     = "10.0.5.0/24"
}

variable "private_db_subnet_az2_cidr" {
  description = "CIDR for private DB subnet in us-east-1b"
  type        = string
  default     = "10.0.6.0/24"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-0b86aaed8ef90e45f" # Example AMI ID, replace with a valid one

}

variable "environment" {
  description = "Environment type: dev or prod"
  type        = string
}
