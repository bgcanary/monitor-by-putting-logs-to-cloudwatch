# monitor-by-putting-logs-to-cloudwatch
monitor by putting logs to cloudwatch.

## Operating specifications

1. Crontab publishes crontab data to AWS CloudWatch Logs.
2. CloudWatch Alarm publish alert if Logs apply to Metric Filter or Crontab stop.

# Deploying
## Requirements
- AWS
  - AWS Account
  - Python 3.7 or greater
  - AWS CLI latest
- Linux
  - systemctl
  - aws-cli

## Instructions
1. Create SNS Topic
2. Deploy CloudFormation
3. Attach IAM Role
4. Set monitor-by-putting-logs-to-cloudwatch.sh
5. Set crontab

### Create SNS Topic
This System need AWS SNS Topic.

### Deploy CloudFormation
1. Deploy monitor-by-putting-logs-to-cloudwatch.yml to CloudFormation in AWS Console.

### Attach IAM Role
1. Attach IAM Role with bellow IAM Policy to EC2 instance etc..

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```

### Set monitor-by-putting-logs-to-cloudwatch.sh
1. cp monitoring-by-put-cloudwatchlog.sh
2. `sudo chmod 755 monitor-by-putting-logs-to-cloudwatch.sh`


### Set crontab
1. Set crontab
```
$ crontab -e
```
edit crontab by vi or etc...
```
* * * * * /home/ubuntu/monitor-by-putting-logs-to-cloudwatch.sh hello.service /aws/ec2/service-status status  > /var/log/monitor-by-putting-logs-to-cloudwatch.log 2>&1
```