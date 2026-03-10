# =======================================
# Root Main Terraform - Calls all modules
# =======================================

terraform {
  required_version = ">= 1.4.0"
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  token = var.github_token
}

# -------------------------
# Network Module
# -------------------------
module "network" {
  source     = "./modules/network"
  # vpc_id     = data.aws_vpc.default.id
  # subnet_ids = data.aws_subnets.default.ids
}

# -------------------------
# Database Module
# -------------------------
module "database" {
  source     = "./modules/database"
  db_password = var.db_password
  rds_sg_id   = module.network.rds_sg_id
  # subnet_ids = module.network.subnet_ids
}

# -------------------------
# Compute Module
# -------------------------
module "compute" {
  source                 = "./modules/compute"
  key_name               = var.key_name
  ec2_sg_id              = module.network.ec2_sg_id
  subnet_ids             = module.network.subnet_ids
  alb_target_group_arn   = module.network.alb_target_group_arn
  user_data_file = "${path.root}/scripts/user-data.sh"
}

# -------------------------
# GitHub Repository File
# -------------------------
resource "github_repository_file" "dbendpoint" {
  repository          = var.github_repo
  branch              = "main"
  file                = "dbserver.endpoint"
  content             = module.database.rds_endpoint
  overwrite_on_create = true
}

