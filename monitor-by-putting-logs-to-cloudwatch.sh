#!/bin/bash -

readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" 
}

export SERVICE_NAME=$1 # hello_world.service
# CloudWatchLogs設定
export LOG_GROUP_NAME=$2  # /aws/ec2/service-status
export LOG_STREAM_NAME=$3 # status
export AWS_DEFAULT_REGION=ap-northeast-1

function main() {
  log "Start batch program."

  # CloudWatchLogsにPUTするメッセージ
  service_active_state=$(systemctl show $SERVICE_NAME | grep "ActiveState=")
  log $service_active_state

  # put-log-eventに利用するトークン
  upload_sequence_token=$(aws logs describe-log-streams --log-group-name "$LOG_GROUP_NAME" --query 'logStreams[?logStreamName==`'$LOG_STREAM_NAME'`].[uploadSequenceToken]' --output text)

  # put-log-eventに利用するタイムスタンプ
  time_stamp=$(date +%s%3N)

  # put-log-eventsの実行
  if [ "$upload_sequence_token" != "None" ]
  then
    # トークン有りの場合
    aws logs put-log-events --log-group-name "$LOG_GROUP_NAME" --log-stream-name "$LOG_STREAM_NAME" --log-events timestamp=$time_stamp,message="$service_active_state" --sequence-token $upload_sequence_token  --output text
  else
    # トークン無しの場合（初回のput）
    aws logs put-log-events --log-group-name "$LOG_GROUP_NAME" --log-stream-name "$LOG_STREAM_NAME" --log-events timestamp=$time_stamp,message="$service_active_state"  --output text
  fi
  log "End batch program."
}

main
