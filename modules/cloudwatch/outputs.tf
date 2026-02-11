output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = var.alarm_email != "" ? aws_sns_topic.alarms[0].arn : ""
}
