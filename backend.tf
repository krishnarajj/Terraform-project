terraform {
  backend "s3" {
    bucket = "S3bucketname"
    key    = "s3fordername/backend"
    region = "regionname"
  }
}