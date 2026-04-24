
sed 's/999-SNAPSHOT/3.32.0/g' "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-simple-rest-aot/pom.xml" > "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-simple-rest-aot/pom.xml.2"
mv "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-simple-rest-aot/pom.xml.2" "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-simple-rest-aot/pom.xml"

require_java "25+"
compile_maven "${REPO_NAME}/quarkus-simple-rest-aot" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
copy_build_artifacts "${REPO_NAME}/quarkus-simple-rest-aot" "quarkus-simple-rest-aot" "target/quarkus-app/app" "target/quarkus-app/lib" "target/quarkus-app/quarkus" "target/quarkus-app/quarkus-app-dependencies.txt" "target/quarkus-app/quarkus-run.jar"
