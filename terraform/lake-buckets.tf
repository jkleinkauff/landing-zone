resource "aws_s3_bucket" "lake-bucket" {
  bucket = "jho-lake-tf"
  acl    = "private"

  tags = {
    Name        = "jho-lake-tf"
  }
}

resource "aws_s3_bucket_object" "raw_department" {
  bucket = aws_s3_bucket.lake-bucket.bucket
  key    = "landing/raw_departments.csv"
  source = "../lake_raw_data/departments.csv"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../lake_raw_data/departments.csv")
}

resource "aws_s3_bucket_object" "dummy_raw_zone" {
  bucket = aws_s3_bucket.lake-bucket.bucket
  key    = "raw/readme.txt"
  source = "../lake_raw_data/readme.txt"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../lake_raw_data/readme.txt")
}
#dummy