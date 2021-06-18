resource "aws_s3_bucket" "my_app_storage" {
  bucket = "my-app-bucket"
  acl    = "public"
}

resource "aws_s3_bucket_policy" "my_app_storage_policy" {
  bucket = aws_s3_bucket.my_app_storage.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::123456789101:root"
                ]
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:GetBucketLocation",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "${aws_s3_bucket.my_app_storage.arn}",
                "${aws_s3_bucket.my_app_storage.arn}/*"
            ]
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.my_app_storage.arn}/*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "1.2.3.4/32"
                }
            }
        }
    ]
}
POLICY
}

