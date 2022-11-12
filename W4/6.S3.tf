resource "aws_s3_bucket" "s3" {
  bucket = lower(
      format(
        "%s-%s-%s-s3",
      var.title,var.environments,var.subtitle
      )
  ) 
  acl    = "private"
}
