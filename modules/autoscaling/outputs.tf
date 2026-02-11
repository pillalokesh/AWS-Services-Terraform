output "autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  value       = aws_autoscaling_group.ec2_asg.name
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.ec2_template.id
}
