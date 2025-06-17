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

output "db_parameter_group_id" {
  description = "The parameter group ID of the RDS instance"
  value       = aws_db_parameter_group.rds.id
}

output "db_option_group_id" {
  description = "The option group ID of the RDS instance"
  value       = aws_db_option_group.rds.id
} 