# AWS Three-Tier Architecture Configuration
# Copy this file to infra/envs/{environment}/terraform.tfvars and customize the values

# Basic Configuration
region = "us-east-1"
env_name = "dev"
project_prefix = "savitarainfotel"
aws_profile = ""  # Leave empty for default AWS profile

# Network Configuration
vpc_cidr = "10.0.0.0/16"
az_count = 2

# Optional: Specify custom Availability Zones
# azs = ["us-east-1a", "us-east-1b"]

# Optional: Specify custom subnet CIDRs (if not specified, they will be calculated automatically)
# public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
# private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
# private_db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]

# Network Feature Flags
enable_nat_gateway = true
single_nat_gateway = true  # Set to false for HA (one NAT gateway per AZ)
enable_flow_logs   = false # Enable VPC Flow Logs for monitoring
enable_nacls       = false # Enable Network ACLs for additional security

# ===================================
# Application Configuration
# ===================================

# REQUIRED: SSL Certificate ARN from AWS Certificate Manager
certificate_arn = "arn:aws:acm:us-east-1:295993620434:certificate/83b4d6f3-e53e-484f-9081-46f33151ff35"

# REQUIRED: Your domain name (must have a hosted zone in Route53)
domain_name = "maazkhan.xyz"

# Subdomain for this environment (will create subdomain.example.com)
subdomain = "savitarainfotel"

# ===================================
# Web Tier Configuration
# ===================================

web_instance_type    = "t3.micro"  # EC2 instance type
web_min_capacity     = 1           # Minimum number of instances
web_max_capacity     = 3           # Maximum number of instances
web_desired_capacity = 2           # Desired number of instances

# ===================================
# Database Configuration
# ===================================

db_instance_class     = "db.t3.micro"  # RDS instance class
db_allocated_storage  = 20             # Storage in GB
db_engine_version     = "8.0"          # MySQL version
db_name               = "savitaradb"     # Database name
db_username           = "admin"        # Database username
# db_password - Set via GitHub Secrets (TF_VAR_db_password) in CI/CD

# Resource Tags
tags = {
  Environment = "dev"
  Project     = "AWS-three-tier-architecture"
  Owner       = "savitarainfotel"
  ManagedBy   = "Maaz-Khan"
}