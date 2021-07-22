##########################################
#   Define RDS Postgresql Subnet Group   #
##########################################
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
  engine_version             = "12.6"
  auto_minor_version_upgrade = "true"
  parameter_group_name       = "default.postgres12"
  instance_class             = var.db_type
  identifier                 = "${var.var_name}-${var.var_dev_environment}-octopus-db"
  name                       = "default_db"
  username                   = var.var_username_db
  password                   = var.var_password_db
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
  final_snapshot_identifier  = "${var.var_name}-${var.var_dev_environment}-octopus-final-snapshot"
  copy_tags_to_snapshot      = true
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.db_sg.id]
  tags = {
    Name               = "${var.var_name}-${var.var_dev_environment}-octopus-db"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

##########################################
# Create RDS instance for octopus server #
##########################################
resource "aws_db_instance" "all_rds_instance" {
  allocated_storage          = 20
  storage_type               = "gp2"
  engine                     = "postgres"
  engine_version             = "12.6"
  auto_minor_version_upgrade = "true"
  parameter_group_name       = "default.postgres12"
  instance_class             = var.db_type
  identifier                 = "${var.var_name}-${var.var_dev_environment}-all-db"
  name                       = "default_db"
  username                   = var.var_username_db
  password                   = var.var_password_db
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
    Name               = "${var.var_name}-${var.var_dev_environment}-all-db"
    "user:Client"      = var.var_name
    "user:Environment" = var.var_dev_environment
  }
}

##########################################
#    Create databases on RDS instance    #
##########################################
provider "postgresql" {
  host             = aws_db_instance.octopus_rds_instance.address
  alias            = "octopus"
  database         = "postgres"
  username         = aws_db_instance.octopus_rds_instance.username
  password         = aws_db_instance.octopus_rds_instance.password
  sslmode          = "disable"
  expected_version = aws_db_instance.octopus_rds_instance.engine_version
}

provider "postgresql" {
  host             = aws_db_instance.all_rds_instance.address
  alias            = "all"
  database         = "postgres"
  username         = aws_db_instance.all_rds_instance.username
  password         = aws_db_instance.all_rds_instance.password
  sslmode          = "disable"
  expected_version = aws_db_instance.all_rds_instance.engine_version
}

resource "postgresql_database" "octopus" {
  count    = var.var_ums ? 1 : 0
  provider = postgresql.octopus
  name     = "octopus_db"
}

resource "postgresql_database" "ums" {
  count    = var.var_ums ? 1 : 0
  provider = postgresql.octopus
  name     = "ums_db"
}

resource "postgresql_database" "quizz" {
  count    = var.var_quizz ? 1 : 0
  provider = postgresql.all
  name     = "quizz_db"
}

resource "postgresql_database" "analytics" {
  count    = var.var_analytics ? 1 : 0
  provider = postgresql.all
  name     = "octopus_analytics_db"
}

resource "postgresql_database" "comments" {
  count    = var.var_comments ? 1 : 0
  provider = postgresql.all
  name     = "octopus_comments_db"
}

resource "postgresql_database" "chat" {
  count    = var.var_chat ? 1 : 0
  provider = postgresql.all
  name     = "octopus_chat_db"
}

resource "postgresql_database" "ecommerce" {
  count    = var.var_ecommerce ? 1 : 0
  provider = postgresql.all
  name     = "octopus_ecommerce_db"
}

resource "postgresql_database" "subscription" {
  count    = var.var_subscription ? 1 : 0
  provider = postgresql.all
  name     = "octopus_subscription_db"
}

resource "postgresql_database" "schedule" {
  count    = var.var_schedule ? 1 : 0
  provider = postgresql.all
  name     = "schedule_db"
}

resource "postgresql_database" "log" {
  provider = postgresql.all
  name     = "octopus_log_db"
}