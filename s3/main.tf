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

# S3 bucket for static website hosting
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name        = "${var.project_name}-website"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Enable versioning
resource "aws_s3_bucket_versioning" "website" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "website" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.website.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
  }
}

# CORS configuration
resource "aws_s3_bucket_cors_configuration" "website" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = var.cors_max_age_seconds
  }
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Bucket policy for public access
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.website.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.website.bucket}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-cloudfront"
    Environment = var.environment
    Project     = var.project_name
  })
}

output "website_endpoint" {
  description = "The website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudfront_domain" {
  description = "The CloudFront domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.website.arn
} 