variable "bucket_name" {
  default = "Test-CI-CD-20220621"
}

resource "aws_s3_bucket" "react_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  server_side_encryption_configuration{
    rule{
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  policy = <<EOF
    {
        "Id" : "bucket_policy_site",
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Sid": "PublicReadGetObject",
                "Action": ["s3:GetObject"],
                "Effect": "Allow",
                "Resource": "arn:aws:s3:::${var.bucket_name}/*",
                "Principal": "*"
            }
        ]
    }
    EOF

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  versioning {
    enabled = true
  }
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST" ]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}


output "website_domain" {
  value = aws_s3_bucket.react_bucket.website_domain
}
output "website_endpoint" {
  value = aws_s3_bucket.react_bucket.website_endpoint
}

# Uploading build files to s3 bucket

#resource "null_resource" "remove_and_upload_to_s3" {
#  provisioner "local-exec" {
#    command = "aws s3 sync ./build s3://register-login-2022/ --delete"
#  }
#}

# resource "aws_api_gateway_rest_api" "rest_api"{
#     name = var.rest_api_name
# }

# variable "rest_api_name"{
#     type = string
#     description = "Name of the API Gateway created"
#     default = "terraform-api-gateway-example"
# }

# module "api_gateway" {
#   source = "./modules/api_gateway"
# }
