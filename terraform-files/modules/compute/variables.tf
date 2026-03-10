variable "key_name" {}
variable "ec2_sg_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "alb_target_group_arn" {}
variable "user_data_file" {
  description = "Path to the user-data.sh script"
  type        = string
}