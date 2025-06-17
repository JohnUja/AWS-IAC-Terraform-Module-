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