
# The setup script manages any work that needs to be done to prepare the
# application being tested for execution, such as compiling the code.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

# Compile Quarkus app normally
require_java "25"
compile_maven "${REPO_NAME}-benchmark"
require_java "25+"
compile_maven "${REPO_NAME}-wrapper" "-Dquarkus.package.jar.type=aot-jar"
copy_build_artifacts "${REPO_NAME}-wrapper" "quarkus-aot-jar" "target/quarkus-app/"
