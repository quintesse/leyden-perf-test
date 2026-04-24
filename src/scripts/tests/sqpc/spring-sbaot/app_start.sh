
NAME=$1

TEST_JAVA_OPTS="${TEST_JAVA_OPTS:-} -Dspring.aot.enabled=true" start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/springboot3/spring-buildpack/application/springboot3.jar"
