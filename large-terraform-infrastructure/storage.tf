##############################
# Create required S3 buckets #
##############################
resource "aws_s3_bucket" "s3bucket" {
  for_each = toset(var.s3bucket_name)
  bucket   = "${var.var_name}-${var.var_dev_environment}-${each.key}"
  acl      = "private"

  versioning {
    enabled = false
  }

  policy = each.key == "chat-server-canned-attachments" ? local.policy_file : null

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-${each.key}"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}
