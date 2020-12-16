######################################
# Define RDS Postgresql Subnet Group #
######################################
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.var_name}-subnet-db-public"
  subnet_ids = aws_subnet.public_subnets.*.id
  tags = {
    Name               = "${var.var_name}-subnet-db-public"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

##########################################
# Create RDS instance for octopus server #
##########################################
resource "aws_db_instance" "octopus_rds_instance" {
  allocated_storage          = 20
  storage_type               = "gp2"
  engine                     = "postgres"
  engine_version             = "9.6.11"
  auto_minor_version_upgrade = "true"
  parameter_group_name       = "default.postgres9.6"
  instance_class             = var.db_type
  identifier                 = "${var.var_name}-${var.var_dev_environment}-all-db"
  name                       = "octopus_server_db"
  username                   = var.username_db
  password                   = var.password_db
  multi_az                   = "false"
  backup_retention_period    = 7
  backup_window              = "04:00-04:30"
  maintenance_window         = "sun:04:30-sun:05:30"
  monitoring_interval        = 0
  iops                       = 0
  publicly_accessible        = "true"
  port                       = 5432
  ca_cert_identifier         = "rds-ca-2019"
  apply_immediately          = "true"
  skip_final_snapshot        = "false"
  final_snapshot_identifier  = "${var.var_name}-${var.var_dev_environment}-final-snapshot"
  copy_tags_to_snapshot      = true
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.db_sg.id]
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-db-all"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

#############################################
# Create missing databases on RDS instances #
#############################################
provider "postgresql" {
  host             = aws_db_instance.octopus_rds_instance.address
  alias            = "octopus"
  database         = "postgres"
  username         = var.username_db
  password         = var.password_db
  sslmode          = "disable"
  expected_version = aws_db_instance.octopus_rds_instance.engine_version
}

resource "postgresql_database" "ums" {
  count    = var.analytics ? 1 : 0
  provider = postgresql.octopus
  name     = "ums_db"
}

resource "postgresql_database" "analytics" {
  count    = var.analytics ? 1 : 0
  provider = postgresql.octopus
  name     = "octopus_analytics_db"
}

resource "postgresql_database" "comments" {
  count    = var.analytics ? 1 : 0
  provider = postgresql.octopus
  name     = "octopus_comments_db"
}

resource "postgresql_database" "chat" {
  count    = var.analytics ? 1 : 0
  provider = postgresql.octopus
  name     = "octopus_chat_db"
}

resource "postgresql_database" "ecommerce" {
  count    = var.analytics ? 1 : 0
  provider = postgresql.octopus
  name     = "octopus_ecommerce_db"
}