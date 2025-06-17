# AWS Infrastructure Modules

A collection of reusable Terraform modules for building scalable and secure AWS infrastructure on the go. These modules are designed to work together to create a complete infrastructure for most modern day web applications, with a focus on security, scalability, and best practices.

## Project Overview

This project provides a set of Terraform modules that can be used to deploy a complete AWS infrastructure. The modules are designed to be modular, reusable, and follow AWS best practices. The infrastructure is suitable for web applications that require:

- Secure networking with VPC *
- Web application hosting *
- Database management *
- User authentication *
- Static content delivery *
- Security and compliance *

## Modules

### VPC Module
- Creates a VPC with public and private subnets
- Configures NAT Gateway for private subnet internet access
- Sets up route tables and internet gateway
- Outputs subnet IDs and VPC information

### Security Module
- Creates security groups for different components
- Configures IAM roles and policies
- Sets up AWS WAF rules
- Manages security group rules

### EC2 Module
- Deploys EC2 instances in private subnets
- Configures auto-scaling groups
- Sets up load balancers
- Manages instance profiles and security

### S3 Module
- Creates S3 buckets for static content
- Configures bucket policies
- Sets up CloudFront distributions
- Manages static website hosting

### RDS Module
- Deploys PostgreSQL RDS instances
- Configures database security groups
- Sets up backup and maintenance windows
- Manages database parameters

### Cognito Module
- Creates user pools for authentication
- Configures user pool clients
- Sets up identity providers
- Manages user attributes and policies

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- Basic understanding of AWS services and Terraform

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/terraform-aws-modules.git
cd terraform-aws-modules
```

2. Initialize Terraform:
```bash
terraform init
```

3. Create a `terraform.tfvars` file with your configuration:
```hcl
project_name = "your-project"
environment  = "dev"
region       = "us-west-2"
```

## Usage

1. Create a new Terraform configuration:
```hcl
module "vpc" {
  source = "./vpc"
  
  project_name = var.project_name
  environment  = var.environment
  region       = var.region
}

module "security" {
  source = "./security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# Add other modules as needed
```

2. Apply the configuration:
```bash
terraform plan
terraform apply
```

## Project Structure

```
terraform-aws-modules/
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── security/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ec2/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── s3/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── rds/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── cognito/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or contact the maintainers.

## Authors

- John C. Uja - Initial work

## Role
 Cloud DevOps and Network Automation Engineer

## Acknowledgments

- AWS Documentation
- Terraform Documentation
- HashiCorp Best Practices 