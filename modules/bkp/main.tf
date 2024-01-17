resource "aws_iam_role" "backup_iam_role" {
  name = "AWSBackupEKS${local.environment}Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "backup_for_backup_policy" {
  role       = aws_iam_role.backup_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "backup_for_restores_policy" {
  role       = aws_iam_role.backup_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}


resource "aws_backup_vault" "backup_vault" {
  name = "${var.prefix_name}-backup-vault"

  tags = var.tags
}

resource "aws_backup_plan" "backup_plan" {
  name = "${var.prefix_name}-plan"

  rule {
    rule_name         = "${var.prefix_name}-backup-rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 9 * * ? *)"

    lifecycle {
      delete_after = 7
    }
  }
  tags = var.tags

  depends_on = [aws_backup_vault.backup_vault]
}

resource "aws_backup_selection" "backup_selection" {
  name         = "${var.prefix_name}-backup-selection"
  iam_role_arn = aws_iam_role.backup_iam_role.arn
  plan_id      = aws_backup_plan.backup_plan.id

  resources = var.resources

  depends_on = [aws_iam_role.backup_iam_role, aws_backup_plan.backup_plan]
}

locals {
  environment = title(var.environment)
}