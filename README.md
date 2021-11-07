# monitor-by-putting-logs-to-cloudwatch
monitor by putting logs to cloudwatch.

## Operating specifications

1. Crontab publishes crontab data to AWS SNS.
2. AWS Lambda analysis received crontab data and email result.
3. CloudWatchAlerm publish alert if Crontab or AWS lambda stop.

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
1. Set monitoring-by-put-cloudwatchlog.sh
2. Set crontab

### Set monitoring-by-put-cloudwatchlog.sh
1. cp monitoring-by-put-cloudwatchlog.sh
2. `sudo chmod 755 monitoring-by-put-cloudwatchlog.sh`


### Set crontab
1. Set crontab
```
$ crontab -e
```
edit crontab by vi or etc...
```
* * * * * /home/ubuntu/monitoring-by-put-cloudwatchlog.sh hello.service /aws/ec2/service-status status  > /var/log/monitoring-by-put-cloudwatchlog.log 2>&1
```