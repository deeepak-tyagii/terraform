output "s3-id" {
  value = module.s3_bucket.s3_bucket_arn
}

output "hello-world" {
  value = "Hello World from Outputs!"
  description = "Hello world Description"
}