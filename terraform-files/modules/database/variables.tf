variable "rds_sg_id" {
  type        = string
  description = "RDS Security Group ID"
}

variable "db_password" {
  type        = string
  description = "RDS password"
  sensitive   = true
}