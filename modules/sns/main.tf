resource "aws_sns_topic" "alerts" {
  name = "ec2-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "m.dochevv@gmail.com"  
}