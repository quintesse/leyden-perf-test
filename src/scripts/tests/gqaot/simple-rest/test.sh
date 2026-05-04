
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_start)
        start_app "${TESTID}" "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/target/quarkus-app/quarkus-run.jar"
        ;;
    setup)
        REPO_URL="https://github.com/gsmet/quarkus-aot.git"
        clone "${REPO_URL}"
        [[ $CLONE_CHANGED -eq 1 ]] || return 0

        sed 's/999-SNAPSHOT/3.32.0/g' "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml" > "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml.2"
        mv "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml.2" "${TEST_TEST_CACHE}/repo/quarkus-simple-rest-aot/pom.xml"

        require_java "25+"
        compile_maven "repo/quarkus-simple-rest-aot" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
        ;;
esac
