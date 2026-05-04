
# The test.sh script handles all actions for the test suite.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_stop)
        stop_app "${TESTID}"
        ;;
esac
