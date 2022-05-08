
resource "aws_s3_bucket" "loljoa2-s3" {
  bucket = "loljoa2-bucket"

  tags = {
    Name = "loljoa2-s3"
    Environment = "Dev"
  }
}

resource "aws_s3_access_point" "loljoa2-s3-access" {
  bucket     = aws_s3_bucket.loljoa2-s3.id
  name       = "loljoa2-s3-access"

  vpc_configuration {
    vpc_id = aws_vpc.loljoa2-vpc.id
  }
}


# resource "aws_s3_bucket_acl" "loljoa2-elb-logs" {
#  bucket = "loljoa2-elb-logs"
#  acl    = "log-delivery-write"
# }
