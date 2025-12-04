#!/bin/bash

set -euo pipefail

# Clones or updates a git repository.
# The repository is cloned into TEST_APPS_DIR/<repository>.
# Arguments:
#   repository - repository name (used for folder name under TEST_APPS_DIR)
#   repo_url   - URL of the git repository
# Variables used:
#   TEST_APPS_DIR - base directory where application code is stored
# Returns:
#   0 if the repository was cloned/updated successfully, non-zero otherwise.
function clone() {
	local repository=$1
	local repo_url=$2

	local result
    if [[ ! -d ${TEST_APPS_DIR}/$repository ]]; then
      echo "   - Cloning repository '$repository'..."
	  local result=0
      git clone -q --depth 1 "$repo_url" "${TEST_APPS_DIR}/$repository" > /tmp/leyden-perf-test-clone-$$.log 2>&1 || result=$?
      if [ $result -ne 0 ]; then
         echo -e "   - ${NORMAL}${RED}✗ Repository '$repository' failed to clone.${NORMAL}"
      else 
         echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Repository '$repository' cloned.${NORMAL}${CLREOL}"
      fi
    else 
      echo "   - Updating repository '$repository'..."
	  set +e
      if pushd "${TEST_APPS_DIR}/$repository" > /tmp/leyden-perf-test-clone-$$.log 2>&1; then
	      if git reset HEAD --hard > /tmp/leyden-perf-test-clone-$$.log 2>&1; then
		      git pull > /tmp/leyden-perf-test-clone-$$.log 2>&1
		  fi
	  fi
	  result=$?
	  set -e
      if [ $result -ne 0 ]; then
         echo -e "   - ${NORMAL}${RED}✗ '$repository' failed to update.${NORMAL}"
		 cat /tmp/leyden-perf-test-clone-$$.log
      else 
         echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ '$repository' updated.${NORMAL}${CLREOL}"
      fi
      popd > /dev/null
    fi
	return $result
}

# Compiles a Maven application located in TEST_APPS_DIR/<repository>.
# Output will only be shown if the build fails.
# Arguments:
#   repository - repository name (used for folder name under TEST_APPS_DIR)
#   opts       - additional options to pass to Maven
# Variables used:
#   TEST_APPS_DIR - base directory where application code is stored
# Returns:
#   0 if the application was compiled successfully, non-zero otherwise.
function compile_maven() {
    local repository=$1
    local opts=${2:-}

    echo "   - Compiling application '$repository'..."
	set +e
    if pushd "${TEST_APPS_DIR}/$repository" > /tmp/leyden-perf-test-build-$$.log 2>&1; then
	    ./mvnw clean package -DskipTests $opts > /tmp/leyden-perf-test-build-$$.log 2>&1
	fi
    local result=$?
	set -e
    if [ $result -ne 0 ]; then
       echo -e "   - ${NORMAL}${RED}✗ '$repository' failed to build.${NORMAL}"
	   cat /tmp/leyden-perf-test-build-$$.log
    else 
       echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ '$repository' built.${NORMAL}${CLREOL}"
	   rm /tmp/leyden-perf-test-build-$$.log
    fi
    popd > /dev/null
    return $result
}

# Copies build artifacts from a repository to the TEST_BUILDS_DIR.
# Arguments:
#   repository - repository name (used for folder name under TEST_APPS_DIR)
#   subfolder  - subfolder under TEST_BUILDS_DIR/<repository> where artifacts will be copied
#   artifacts  - list of files/folders (relative to TEST_APPS_DIR/<repository>) to copy
# Variables used:
#   TEST_APPS_DIR  - base directory where application code is stored
#   TEST_BUILDS_DIR - base directory where build artifacts are stored
# Returns:
#   0 if the artifacts were copied successfully, non-zero otherwise.
function copy_build_artifacts() {
	local repository=$1
	local subfolder=$2
	local artifacts=( "${@:3}" )

	local dest="${TEST_BUILDS_DIR}/$repository/$subfolder"
	echo "   - Copying build artifacts for '$repository'..."
	rm -rf "${dest:?}"
	mkdir -p "$dest"
	pushd "$TEST_APPS_DIR/$repository" > /dev/null
	cp -a "${artifacts[@]}" "$dest"
	popd > /dev/null
	echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Build artifacts for '$repository' copied.${NORMAL}${CLREOL}"
}

# Ensures that the specified Java version is available.
# Arguments:
#   version - Java version to ensure is available
function require_java() {
	local version=$1
	echo "   - Ensuring Java $version is available..."
	eval "$("${TEST_DIR}"/jbang jdk env "$version")"
	echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Java $version set as active.${NORMAL}${CLREOL}"
}
