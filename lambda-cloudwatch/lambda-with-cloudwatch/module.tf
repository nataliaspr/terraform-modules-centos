module "notify_slack" {
  source = "../modules/lambda"


  slack_webhook_url = "https://hooks.slack.com/services/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"
  slack_username    = "natalia_sprinceana"
  slack_channel     = "21b-centos"

  lambda_policy_name = "lambda_policy"
  lambda_role_name   = "lambda_role"
  function_name      = "lambda_function"
  sns_topic_name     = "High_CPU_Utilization"

}

module "cloudwatch_alarm_for_exchange_rds" {
  source = "../modules/cloudwatch-alarm"

  alarm_name          = "High CPU 80% for RDS-Exchange"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  datapoints_to_alarm = 1
  alarm_description   = "RDS Postgres High CPU 80%"
  actions_enabled     = "true"
  alarm_actions       = [module.notify_slack.aws_sns_topic_arn]
  ok_actions          = []
  dimensions = {
    DBInstanceIdentifier = "rds-postgres-exchange"

  }

}

module "cloudwatch_alarm_for_versus_rds" {
  source = "../modules/cloudwatch-alarm"

  alarm_name          = "High CPU 80% RDS-Versus"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  datapoints_to_alarm = 1
  alarm_description   = "RDS MySQL High CPU 80%"
  actions_enabled     = "true"
  alarm_actions       = [module.notify_slack.aws_sns_topic_arn]
  ok_actions          = []
  dimensions = {
    DBInstanceIdentifier = "rds-versus"

  }

}

module "cloudwatch_alarm_EKS_Cluster" {
  source = "../modules/cloudwatch-alarm"

  alarm_name          = "EKS Cluster High CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  datapoints_to_alarm = 1
  alarm_description   = "EKS Cluster high CPU 80%"
  actions_enabled     = "true"
  alarm_actions       = [module.notify_slack.aws_sns_topic_arn]
  ok_actions          = []
  dimensions = {
    AutoScalingGroupName = "eks-OnDemand-21b-project-34be8ad0-eb1e-4ff0-521c-da8cbc76049b"

  }

}
