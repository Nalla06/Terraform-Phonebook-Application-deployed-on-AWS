output "alb_dns_name" {
  value = module.network.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
  description = "Endpoint of the RDS instance"
}

output "asg_name" {
  value = module.compute.asg_name
  description = "Name of the Auto Scaling Group"
}