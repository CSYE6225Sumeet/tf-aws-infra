resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name = "cloudwatch-agent-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:PutRetentionPolicy",
          "cloudwatch:PutMetricData"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
  role       = aws_iam_role.ec2_s3_role.name
}