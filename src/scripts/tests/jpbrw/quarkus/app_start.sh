
# The app_start script starts the application to be tested.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

NAME=$1

start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}-wrapper/quarkus-aot-jar/quarkus-app/quarkus-run.jar"
