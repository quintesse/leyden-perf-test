#!/bin/bash

if ! command -v oha >/dev/null 2>&1
then
    echo "Command 'oha' not found, please install it, see https://github.com/hatoo/oha"
    exit 1
fi

rm spring.out quarkus.out

# Run performance tests for Spring Boot Petclinic
java -jar spring-petclinic/target/*.jar &
JAVA_PID=$!
sleep 10
if kill -0 $JAVA_PID > /dev/null 2>&1; then
	./_perftest_spring.sh
	kill $JAVA_PID
else
	echo Spring Boot Petclinic not running
fi
sleep 3

# Run performance tests for Quarkus Petclinic
java -jar quarkus-petclinic/target/*.jar &
JAVA_PID=$!
sleep 10
if kill -0 $JAVA_PID > /dev/null 2>&1; then
	./_perftest_quarkus.sh
	kill $JAVA_PID
else
	echo Quarkus Petclinic not running
fi

echo ""
echo Results for Spring Boot performance tests:
cat spring.out

echo ""
echo Results for Quarkus performance tests:
cat quarkus.out

