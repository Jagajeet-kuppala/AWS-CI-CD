resource "aws_kms_key" "key" {
  description             = "KMS key"
}

resource "aws_kms_alias" "key_alias" {
    name          = var.key_alias
    target_key_id = aws_kms_key.key.key_id
}