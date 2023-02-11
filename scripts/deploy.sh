#!/usr/bin/env bash

REPOSITORY=/home/ubuntu/server
cd $REPOSITORY || exit

APP_NAME=fitback-security
JAR_NAME=$(ls $REPOSITORY/build/libs/ | grep '.jar' | tail -n 1)
JAR_PATH=$REPOSITORY/build/libs/$JAR_NAME

echo "Stopping the current instance of $APP_NAME if it is running..."
CURRENT_PID=$(pgrep -f "$APP_NAME")
if [ -n "$CURRENT_PID" ]; then
echo "Killing process with PID $CURRENT_PID"
kill -15 "$CURRENT_PID"
sleep 5
else
echo "No process found to stop."
fi

echo "Starting new instance of $APP_NAME..."
nohup java -jar -Dspring.config.location=classpath:/,file:///home/ubuntu/study-app-env/application-prod.properties "$JAR_PATH" >> /home/ubuntu/deploy.log 2>&1 &

echo "[$(date)] Deployment of $APP_NAME completed" >> /home/ubuntu/deploy.log
