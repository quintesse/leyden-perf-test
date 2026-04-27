
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_start)
        # The app_start action starts the application to be tested.
        # This action is optional and can be removed if not needed.
        # Typical implementation:
        #start_app "${TESTID}" "path/to/your/app.jar"
        ;;
    app_stop)
        # The app_stop action stops the application that was tested.
        # This action is optional and can be removed if not needed.
        # Typical implementation:
        stop_app "${NAME}"
        ;;
    infra_start)
        # The infra_start action starts any infrastructure services required by the application.
        # IMPORTANT: This action should wait and return only when the infrastructure
        # is fully started and ready to use!
        # This action is optional and can be removed if not needed.
        ;;
    infra_stop)
        # The infra_stop action stops any infrastructure services required by the application.
        # This action is optional and can be removed if not needed.
        ;;
    setup)
        # The setup action manages any work that needs to be done to prepare the
        # application being tested for execution, such as compiling the code.

        # Put your setup code here
        echo "Compiling example_test..."

        # This action is optional and can be removed if not needed
        ;;
esac
