#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

sed 's/localhost:5433/localhost:5432/g' "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/src/main/resources/application.properties" > "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/src/main/resources/application.properties.new"
sed 's/quarkus-tribe-krd/gqaot/g' "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/src/main/resources/application.properties.new" > "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/src/main/resources/application.properties.new2"
mv "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/src/main/resources/application.properties.new2" "${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/src/main/resources/application.properties"

require_java "25+"
compile_maven "${REPO_NAME}/quarkus-hibernate-orm-tribe-krd" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
copy_build_artifacts "${REPO_NAME}/quarkus-hibernate-orm-tribe-krd" "quarkus-hibernate-orm-tribe-krd" "target/quarkus-app/app" "target/quarkus-app/lib" "target/quarkus-app/quarkus" "target/quarkus-app/quarkus-app-dependencies.txt" "target/quarkus-app/quarkus-run.jar"

dest="${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/quarkus-hibernate-orm-tribe-krd"
pushd "$dest" > /dev/null
rm -rf "${dest:?}/db"
mkdir -p "$dest/db"
cp -a "${TEST_SRC_DIR}/scripts/tests/gqaot/quarkus-hibernate-orm-tribe-krd.sql" "$dest/db"
popd > /dev/null
echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ SQL pre-seeding database script for 'quarkus-hibernate-orm-tribe-krd' copied.${NORMAL}${CLREOL}"
