
TESTID=${1:-}

app_jar="${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/target/quarkus-app/quarkus-run.jar"

app_start() {
    start_app "${TESTID}" "${app_jar}"
}

app_setup() {
    REPO_URL="https://github.com/gsmet/quarkus-aot.git"
    clone "${REPO_URL}"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

    sed 's/999-SNAPSHOT/3.32.0/g' "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml" > "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml.2"
    mv "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml.2" "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml"

    require_java "25+"
    compile_maven "repo/quarkus-simple-rest-aot" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
}

