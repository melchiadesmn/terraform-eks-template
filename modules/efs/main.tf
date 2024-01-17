resource "aws_security_group" "efs_security_group" {
  name        = "${var.prefix_name}-efs"
  description = "Allow EFS access from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [
      var.eks_security_group_id
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    "Name" = "${var.prefix_name}-efs"
  })
}

resource "aws_efs_file_system" "efs" {
  for_each       = toset(var.creation_token)
  creation_token = each.value
  encrypted      = var.encrypted
  tags = merge(var.tags, {
    "Name" = "${each.value}"
  })
}

resource "aws_efs_backup_policy" "efs_backup_policy" {
  for_each       = toset(var.creation_token)
  file_system_id = aws_efs_file_system.efs[each.value].id
  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "efs_mount_target_subnet_0" {
  for_each        = toset(var.creation_token)
  file_system_id  = aws_efs_file_system.efs[each.value].id
  subnet_id       = var.subnet_ids[0]
  security_groups = [aws_security_group.efs_security_group.id]
}

resource "aws_efs_mount_target" "efs_mount_target_subnet_1" {
  for_each        = toset(var.creation_token)
  file_system_id  = aws_efs_file_system.efs[each.value].id
  subnet_id       = var.subnet_ids[1]
  security_groups = [aws_security_group.efs_security_group.id]
}

resource "aws_efs_mount_target" "efs_mount_target_subnet_2" {
  for_each        = toset(var.creation_token)
  file_system_id  = aws_efs_file_system.efs[each.value].id
  subnet_id       = var.subnet_ids[2]
  security_groups = [aws_security_group.efs_security_group.id]
}