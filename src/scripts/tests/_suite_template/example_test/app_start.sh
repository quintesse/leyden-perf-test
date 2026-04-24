
# The app_start script starts the application to be tested.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

# Start the application to be tested
TESTID=$1
# Typical implementation:
#start_app "${TESTID}" "path/to/your/app.jar"
