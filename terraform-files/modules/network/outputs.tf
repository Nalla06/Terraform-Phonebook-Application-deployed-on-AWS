
output "alb_target_group_arn" {
  value = aws_alb_target_group.app_tg.arn
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "subnet_ids" {
  value = data.aws_subnets.default.ids
}