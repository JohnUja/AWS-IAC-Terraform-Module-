variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for the bucket"
  type        = bool
  default     = true
}

variable "enable_cors" {
  description = "Enable CORS for the bucket"
  type        = bool
  default     = true
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_methods" {
  description = "List of allowed methods for CORS"
  type        = list(string)
  default     = ["GET", "PUT", "POST", "DELETE", "HEAD"]
}

variable "cors_allowed_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_max_age_seconds" {
  description = "Max age in seconds for CORS"
  type        = number
  default     = 3000
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 