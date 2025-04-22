resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "high-cpu-asg"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.scale_out_policy_arn]
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "high-memory-cpu-asg"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.scale_out_policy_arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "low-cpu-asg"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.scale_in_policy_arn]
}

resource "aws_cloudwatch_metric_alarm" "memory_low" {
  alarm_name          = "low-memory-asg"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.scale_in_policy_arn]
}

###S3 bucket creation and policy
resource "aws_s3_bucket" "alb_logs" {
  bucket = "my-alb-logs-bucket-${random_string.suffix.result}"

  force_destroy = true

  tags = {
    Name = "ALB Access Logs"
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowELBLogging",
      Effect    = "Allow",
      Principal = {
        Service = "elasticloadbalancing.amazonaws.com"
      },
      Action    = "s3:PutObject",
      Resource  = "${aws_s3_bucket.alb_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    }]
  })
}

data "aws_caller_identity" "current" {}




