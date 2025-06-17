output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.id
}

output "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.arn
}

output "client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.id
}

output "client_secret" {
  description = "The client secret of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.client_secret
  sensitive   = true
}

output "identity_pool_id" {
  description = "The ID of the Cognito Identity Pool"
  value       = aws_cognito_identity_pool.pool.id
}

output "identity_pool_arn" {
  description = "The ARN of the Cognito Identity Pool"
  value       = aws_cognito_identity_pool.pool.arn
} 