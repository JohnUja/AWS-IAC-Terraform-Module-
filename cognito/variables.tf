variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "password_min_length" {
  description = "Minimum length of the password policy"
  type        = number
  default     = 8
}

variable "require_lowercase" {
  description = "Require lowercase characters in the password policy"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Require numbers in the password policy"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Require symbols in the password policy"
  type        = bool
  default     = true
}

variable "require_uppercase" {
  description = "Require uppercase characters in the password policy"
  type        = bool
  default     = true
}

variable "callback_urls" {
  description = "Callback URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["http://localhost:3000"]
}

variable "logout_urls" {
  description = "Logout URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["http://localhost:3000"]
}

variable "allowed_oauth_flows" {
  description = "Allowed OAuth flows for the Cognito User Pool Client"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "Allowed OAuth scopes for the Cognito User Pool Client"
  type        = list(string)
  default     = ["email", "openid", "profile"]
} 