resource "aws_iam_role" "ec2" {
  name = "wordpress-ec2-role"
  assume_role_policy = file("${path.module}/policies/ec2_role.json")
}

resource "aws_iam_policy" "ec2_policy" {
  name   = "ec2-wordpress-policy"
  policy = file("${path.module}/policies/ec2_policy.json")
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "wordpress-instance-profile"
  role = aws_iam_role.ec2.name
}


resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = file("${path.module}/policies/rds_role.json")
}

resource "aws_iam_policy" "rds_cloudwatch_logs" {
  name = "rds-cloudwatch-logs-policy"

 policy = file("${path.module}/policies/rds_policy.json")
}

resource "aws_iam_role_policy_attachment" "rds_logs_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = aws_iam_policy.rds_cloudwatch_logs.arn
}

