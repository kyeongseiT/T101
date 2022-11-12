resource "aws_iam_instance_profile" "ec2s3" {
  name  = "s3_profile"
  role = aws_iam_role.ec2s3.id
}

resource "aws_iam_role" "ec2s3" {
  name = format(
      "%s-%s-%s-s3-role",
      var.title,var.environments,var.subtitle
  )

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2s3" {
  name = format(
      "%s-%s-%s-s3-policy",
      var.title,var.environments,var.subtitle
  )
  role = aws_iam_role.ec2s3.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
