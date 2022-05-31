#!/bin/bash

app='life-biz'
pids=$(ps aux | grep -v grep | grep -v '/bin/bash' | grep java | grep ${app} | awk '{print $2}')

for pid in $pids; do
  kill -9 $pid
done
if [ "$pids" = "" ]; then
  echo "The service is stop sucessful!"
else
  for pid in $pids; do
    kill -9 $pid >/dev/null 2>&1
    sleep 3
    echo "The service is stop sucessful!"
  done
fi

spring_boot_opts="-Dspring.profiles.active=sit"
stdout_log=/data/logs/$app/stdout.out
#iast_opts="-Dmoresec.agentdir=/data/logs/iast -Dmoresec.iast.agent.tag=life-biz -javaagent:/data/app/secagent/iast_agent.jar"
start_cmd="java $spring_boot_opts -Xms1g -Xmx1g -Xss256k -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=256m -XX:-UseBiasedLocking -XX:AutoBoxCacheMax=20000 -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -Djava.security.egd=file:/dev/urandom -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75-XX:+UseCMSInitiatingOccupancyOnly -XX:+ExplicitGCInvokesConcurrent -XX:+ParallelRefProcEnabled -XX:+CMSParallelInitialMarkEnabled -Xloggc:/dev/shm/gc-life-biz.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=10m -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintPromotionFailure -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCID -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data/logs/$app -XX:ErrorFile=/data/logs/$app/hs_err_pid%p.log -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8 -Djava.awt.headless=true -Duser.timezone=GMT+07 -Dapollo.cacheDir=/data/apollo-cache/  -jar /data/app/$app/$app.jar> $stdout_log 2>&1 &"
eval nohup "$start_cmd" &
pids=$(ps aux | grep -v grep | grep -v '/bin/bash' | grep java | grep ${app} | awk '{print $2}')
if [ $? = 0 ]; then
  if [ "$pids" != "" ]; then
    echo "The service is restart sucessful!"
  fi
else
  echo "The service is restart failed!Please check the start scripts!"
fi
