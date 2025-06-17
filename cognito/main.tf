# Cognito User Pool
resource "aws_cognito_user_pool" "pool" {
  name = "${var.project_name}-${var.environment}-user-pool"

  password_policy {
    minimum_length    = var.password_min_length
    require_lowercase = var.require_lowercase
    require_numbers   = var.require_numbers
    require_symbols   = var.require_symbols
    require_uppercase = var.require_uppercase
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  auto_verified_attributes = ["email"]

  tags = merge(var.tags, {
    Name        = "${var.project_name}-user-pool"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "client" {
  name = "${var.project_name}-${var.environment}-client"

  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret = false

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  allowed_oauth_flows  = var.allowed_oauth_flows
  allowed_oauth_scopes = var.allowed_oauth_scopes

  supported_identity_providers = ["COGNITO"]
}

# Cognito Identity Pool
resource "aws_cognito_identity_pool" "pool" {
  identity_pool_name = "${var.project_name}-${var.environment}-identity-pool"

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client.id
    provider_name           = aws_cognito_user_pool.pool.endpoint
    server_side_token_check = false
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-identity-pool"
    Environment = var.environment
    Project     = var.project_name
  })
} 