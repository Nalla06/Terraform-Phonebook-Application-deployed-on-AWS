variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token"
  sensitive   = true
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name where dbendpoint will be stored"
  default     = "phonebook-terraform-project"
}

variable "db_password" {
  type      = string
  sensitive = true
}

