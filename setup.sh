#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export TEST_SRC_DIR=${script_dir}/src
export TEST_APPS_DIR=${script_dir}/apps
export TEST_BUILDS_DIR=${script_dir}/builds

source "${TEST_SRC_DIR}"/scripts/functions.sh
source "${TEST_SRC_DIR}"/scripts/compile/spring-quarkus-perf-comparison.sh

clone() {
	local repository=$1
	local repo_url=$2

	local result
    if [[ ! -d ${TEST_APPS_DIR}/$repository ]]; then
      echo "Clone repository '$repository'"
      git clone --depth 1 "$repo_url" "${TEST_APPS_DIR}/$repository"
	  result=$?
      if [ $result -ne 0 ]; then
         echo -e "   - \033[0;31m✗ '$repository' failed to clone.\033[0m"
      else 
         echo -e "   - \033[0;32m✓ '$repository' cloned.\033[0m"
      fi
    else 
      pushd "${TEST_APPS_DIR}/$repository" > /dev/null
      git reset HEAD --hard >> /dev/null
      git pull >> /dev/null 
	  result=$?
      if [ $result -ne 0 ]; then
         echo -e "   - \033[0;31m✗ '$repository' failed to update.\033[0m"
      else 
         echo -e "   - \033[0;32m✓ '$repository' updated.\033[0m"
      fi
      popd > /dev/null
    fi
	return $result
}

if ! command -v oha >/dev/null 2>&1
then
    echo -e "   - \033[0;31m✗ oha   : Command not found, please install it, see https://github.com/hatoo/oha\033[0m"
else
    echo -e "   - \033[0;32m✓ oha   : Command is installed.\033[0m"
fi

clone "spring-quarkus-perf-comparison" "https://github.com/quarkusio/spring-quarkus-perf-comparison.git"

save_jdk
switch_jdk "21+"

compile_spring_quarkus_perf_comparison

restore_jdk
