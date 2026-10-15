###### Environment Configuration

This folder is a root module that composes the reusable network module in ../../modules.

## Local Development vs CI/CD Setup

### Local Development
For local development, you have two options:

**Option 1: Use Environment Variables (Recommended for CI/CD compatibility)**
Set your AWS credentials using environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

**Option 2: Override the AWS Profile Locally**
If you prefer using AWS profiles for local development:

1. Copy `terraform.tfvars.example` to `terraform.tfvars.local`
2. Set your profile in the local file:
   ```hcl
   aws_profile = "your-profile-name"
   ```
3. Use the local file when running terraform:
   ```bash
   terraform plan -var-file="terraform.tfvars" -var-file="terraform.tfvars.local"
   terraform apply -var-file="terraform.tfvars" -var-file="terraform.tfvars.local"
   ```

### CI/CD Configuration
The main `terraform.tfvars` file is configured for CI/CD environments:
- `aws_profile = ""` - Uses default AWS provider authentication
- AWS credentials are provided via GitHub Secrets or IAM roles
- Database password is provided via GitHub Secrets (`DB_PASSWORD`)

## Security
This project implements secure password management:
- Database passwords are stored in GitHub Secrets for CI/CD
- Runtime passwords are retrieved from AWS Secrets Manager
- No sensitive data is stored in version control
- See [SECURITY.md](../../SECURITY.md) for detailed setup instructions

## Usage
- From `infra/envs` in Windows PowerShell, provide a database password for the current session, then pass the environment-specific variables file explicitly. Terraform does not automatically load files in subdirectories:
  ```powershell
  $securePassword = Read-Host "Database password" -AsSecureString
  $env:TF_VAR_db_password = [System.Net.NetworkCredential]::new("", $securePassword).Password
  terraform plan -var-file="dev/terraform.tfvars"
  # Review the plan, then apply it:
  terraform apply -var-file="dev/terraform.tfvars"
  Remove-Item Env:TF_VAR_db_password
  ```
  Replace `dev` with `staging` or `prod` as needed. Use a unique password of at least 8 characters that meets the database engine's requirements; do not reuse a weak or previously exposed password. Keep database passwords out of committed tfvars files; provide them through the environment, an untracked local variables file, or a CI/CD secret.
- Optional: set AZs and custom subnet CIDRs. If omitted, they are derived from vpc_cidr.
- Toggle feature flags like enable_nat_gateway, enable_flow_logs, enable_nacls.

Outputs provide VPC and subnet IDs to attach compute resources later.
