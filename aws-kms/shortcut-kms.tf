provider "aws" {
  region     = "us-east-2"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
}

resource "aws_kms_key" "shortcut" {
  description             = "Unseal key for shortcut demo"
  deletion_window_in_days = 7
  enable_key_rotation = true

  tags = {
    Name = "shortcut-kms-key"
  }
}

resource "aws_kms_alias" "shortcut" {
  name          = "alias/shortcut-kms-key"
  target_key_id = aws_kms_key.shortcut.key_id
}

resource "aws_iam_policy" "shortcut-kms-policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.shortcut.arn
      },
    ]
  })
}

output "kms_key_arn" {
  value = aws_kms_key.shortcut.arn
}