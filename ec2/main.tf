variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID of the AMI to use"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  tags = merge(var.tags, {
    Name        = "${var.project_name}-instance-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
  })
}

output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_instance.this[*].id
}

output "private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.this[*].private_ip
}

output "public_ips" {
  description = "List of public IP addresses"
  value       = aws_instance.this[*].public_ip
} 