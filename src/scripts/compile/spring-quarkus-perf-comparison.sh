
source "${TEST_SRC_DIR}"/scripts/functions.sh

function compile_spring_quarkus_perf_comparison() {
	# Compile Quarkus app normally
	compile_maven "spring-quarkus-perf-comparison/quarkus3" ""
	copy_build_artifacts "spring-quarkus-perf-comparison/quarkus3" "quarkus3-normal" "target/quarkus-app"

	# Compile Quarkus app as uber-jar
	compile_maven "spring-quarkus-perf-comparison/quarkus3" "-Dquarkus.package.jar.type=uber-jar"
	copy_build_artifacts "spring-quarkus-perf-comparison/quarkus3" "quarkus3-uberjar" "target/quarkus3-runner.jar"

	# Compile Spring Boot app normally
	compile_maven "spring-quarkus-perf-comparison/springboot3" ""
	copy_build_artifacts "spring-quarkus-perf-comparison/springboot3" "spring-normal" "target/springboot3.jar"

	# Compile Spring Boot app as Spring Boot Buildpack Executable
	# Which means preparing for AOT cache and production environment
	# As described in https://docs.spring.io/spring-boot/reference/packaging/efficient.html
	# and in https://docs.spring.io/spring-boot/reference/packaging/aot.html
	compile_maven "spring-quarkus-perf-comparison/springboot3" "-Pnative"
	echo "Extracting Spring Boot Buildpack Executable..."
	local target="${TEST_APPS_DIR}/spring-quarkus-perf-comparison/springboot3/target"
	java -Djarmode=tools -jar "${target}/springboot3.jar" extract --destination "${target}/application" > /dev/null
	copy_build_artifacts "spring-quarkus-perf-comparison/springboot3" "spring-buildpack" "target/application"
}
