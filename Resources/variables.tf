variable "s3_bucket_name" {
    description = "This is to describe the S3 Bucket Name"
    type = string
    default = "terraform-bucket-deepaktyagi"
}

variable "environment"{
    description = "The Environment Name"
    type = string
}