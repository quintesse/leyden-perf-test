
test_repo_path=${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-simple
test_build_path="${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-simple/quarkus-hibernate-orm-simple"

sed -i 's/localhost:5434/localhost:5432/g' "$test_repo_path/src/main/resources/application.properties"
sed -i 's/quarkus-simple/gqaot/g' "$test_repo_path/src/main/resources/application.properties"
sed -i 's/999-SNAPSHOT/3.32.0/g' "$test_repo_path/pom.xml"

require_java "25+"
compile_maven "${REPO_NAME}/quarkus-hibernate-orm-simple" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
copy_build_artifacts "${REPO_NAME}/quarkus-hibernate-orm-simple" "quarkus-hibernate-orm-simple" "target/quarkus-app/app" "target/quarkus-app/lib" "target/quarkus-app/quarkus" "target/quarkus-app/quarkus-app-dependencies.txt" "target/quarkus-app/quarkus-run.jar"

rm -rf "${test_build_path:?}/db"
mkdir -p "$test_build_path/db"
cp -a "${TEST_TEST_DIR}/initdb.sql" "$test_build_path/db"
echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ SQL pre-seeding database script for 'quarkus-hibernate-orm-simple' copied.${NORMAL}${CLREOL}"
