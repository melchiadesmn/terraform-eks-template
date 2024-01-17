resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.prefix_name}-rds-subnet-group"
  description = "Subnet group for RDS"
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix_name}-rds-subnet-group"
    }
  )
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.prefix_name}-rds"
  description = "Allow RDS access from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_security_group_id]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    "Name" = "${var.prefix_name}-rds"
  })
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  name        = "${var.prefix_name}-aurora-pg"
  family      = var.pg_family
  description = "RDS default cluster parameter group"

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  parameter {
    name  = "event_scheduler"
    value = "ON"
  }

  tags = var.tags
}

resource "aws_db_parameter_group" "rds_instance_parameter_group" {
  name        = "${var.prefix_name}-aurora-pg"
  family      = var.pg_family
  description = "RDS default instance parameter group"

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  tags = var.tags
}

resource "aws_rds_cluster" "rds_cluster" {
  count                           = length(var.cluster_identifier)
  cluster_identifier              = "${element(var.cluster_identifier, count.index)}-cluster"
  allow_major_version_upgrade     = true
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameter_group.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  availability_zones              = var.availability_zones
  master_username                 = var.master_username
  master_password                 = var.master_password
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = var.skip_final_snapshot
  vpc_security_group_ids          = [aws_security_group.rds_security_group.id]
  deletion_protection             = var.deletion_protection
  final_snapshot_identifier       = "${element(var.cluster_identifier, count.index)}-final-snapshot"

  tags = merge(
    var.tags,
    {
      "Name" = "${element(var.cluster_identifier, count.index)}-cluster"
    }
  )

  depends_on = [
    aws_security_group.rds_security_group,
    aws_rds_cluster_parameter_group.rds_cluster_parameter_group
  ]
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count                        = length(var.cluster_identifier)
  cluster_identifier           = aws_rds_cluster.rds_cluster[count.index].id
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.rds_cluster[count.index].engine
  engine_version               = aws_rds_cluster.rds_cluster[count.index].engine_version
  performance_insights_enabled = var.performance_insights_enabled
  db_parameter_group_name      = aws_db_parameter_group.rds_instance_parameter_group.name
  identifier                   = "${element(var.cluster_identifier, count.index)}-instance"
  ca_cert_identifier           = var.ca_cert_identifier

  publicly_accessible = var.publicly_accessible

  tags = merge(
    var.tags,
    {
      "Name" = "${element(var.cluster_identifier, count.index)}-instance"
    }
  )

  depends_on = [
    aws_rds_cluster.rds_cluster,
    aws_db_subnet_group.db_subnet_group,
    aws_db_parameter_group.rds_instance_parameter_group
  ]
}