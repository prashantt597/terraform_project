output "bucket_domain_name" {
  value = aws_s3_bucket.main.bucket_regional_domain_name
}

output "random_suffix" {
  value = random_string.suffix.result
}