vpc_cidr                   = "10.1.0.0/16"
public_subnet_az1_cidr     = "10.1.1.0/24"
public_subnet_az2_cidr     = "10.1.2.0/24"
private_app_subnet_az1_cidr = "10.1.3.0/24"
private_app_subnet_az2_cidr = "10.1.4.0/24"
private_db_subnet_az1_cidr  = "10.1.5.0/24"
private_db_subnet_az2_cidr  = "10.1.6.0/24"
ec2_ami_id                 = "ami-0b86aaed8ef90e45f"

# prod.tfvars
environment = "prod"