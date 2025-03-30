output "lb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.my_target_group.arn
}