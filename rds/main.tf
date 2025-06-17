variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where the RDS instance will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB"
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Daily time range during which backups happen"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Weekly time range during which maintenance happens"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "gp2"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "14.7"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# Security group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-rds-sg"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Parameter group
resource "aws_db_parameter_group" "rds" {
  family = "postgres14"
  name   = "${var.project_name}-${var.environment}-pg"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-rds-pg"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Option group
resource "aws_db_option_group" "rds" {
  name                     = "${var.project_name}-${var.environment}-og"
  option_group_description = "Option group for ${var.project_name} RDS instance"
  engine_name              = "postgres"
  major_engine_version     = "14"

  option {
    option_name = "pgAudit"
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-rds-og"
    Environment = var.environment
    Project     = var.project_name
  })
}

# RDS subnet group
resource "aws_db_subnet_group" "rds" {
  name       = "${var.project_name}-${var.environment}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name        = "${var.project_name}-rds-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  })
}

# RDS instance
resource "aws_db_instance" "rds" {
  identifier = "${var.project_name}-${var.environment}"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  parameter_group_name = aws_db_parameter_group.rds.name
  option_group_name    = aws_db_option_group.rds.name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  multi_az            = var.multi_az
  skip_final_snapshot = true
  deletion_protection = var.environment == "prod" ? true : false

  enabled_cloudwatch_logs_exports = ["postgresql"]

  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring.arn

  tags = merge(var.tags, {
    Name        = "${var.project_name}-rds"
    Environment = var.environment
    Project     = var.project_name
  })
}

# IAM role for RDS monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project_name}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name        = "${var.project_name}-rds-monitoring-role"
    Environment = var.environment
    Project     = var.project_name
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

output "db_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.rds.endpoint
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.rds.db_name
}

output "db_username" {
  description = "The master username for the database"
  value       = aws_db_instance.rds.username
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.rds.port
}

output "db_security_group_id" {
  description = "The security group ID of the RDS instance"
  value       = aws_security_group.rds.id
} 