resource "aws_autoscaling_group" "phonebook_asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.subnet_ids
  launch_template {
    id      = aws_launch_template.phonebook_lt.id
    version = "$Latest"
  }
  target_group_arns    = [var.alb_target_group_arn]
  health_check_type    = "ELB"
  health_check_grace_period = 300
}