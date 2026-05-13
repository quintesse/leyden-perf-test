#!/bin/bash

set -euo pipefail

# Clones or updates a git repository.
# The repository is cloned into TEST_TEST_CACHE/<repository>.
# Arguments:
#   repo_url   - URL of the git repository
#   repository - (optional) repository name (used for folder name under TEST_TEST_CACHE, default: "repo")
# Variables used:
#   TEST_TEST_CACHE - cache directory for the current test
# Returns:
#   0 if the repository was cloned/updated successfully, non-zero otherwise.
function clone() {
	local repo_url=$1
	local repository=${2:-repo}

	GIT_CMD=""
	if command -v git >/dev/null 2>&1; then
		GIT_CMD=git
	else
		GIT_CMD="${TEST_DIR}/jbang git@jbangdev"
	fi

	CLONE_CHANGED=0
	local result
    if [[ ! -d ${TEST_TEST_CACHE}/$repository ]]; then
      echo "   - Cloning repository '$repo_url'..."
	  local result=0
      $GIT_CMD clone --quiet --depth 1 "$repo_url" "${TEST_TEST_CACHE}/$repository" > /tmp/leyden-perf-test-clone-$$.log 2>&1 || result=$?
      if [ $result -ne 0 ]; then
         echo -e "   - ${NORMAL}${RED}✗ Repository '$repo_url' failed to clone.${NORMAL}"
      else
         CLONE_CHANGED=1
         echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Repository '$repo_url' cloned.${NORMAL}${CLREOL}"
      fi
    else 
      echo "   - Updating repository '$repo_url'..."
	  set +e
	  local result=0
      if pushd "${TEST_TEST_CACHE}/$repository" > /tmp/leyden-perf-test-clone-$$.log 2>&1; then
	      if $GIT_CMD reset HEAD --hard > /tmp/leyden-perf-test-clone-$$.log 2>&1; then
		      local before
		      before=$($GIT_CMD rev-parse HEAD)
		      $GIT_CMD pull > /tmp/leyden-perf-test-clone-$$.log 2>&1 || result=$?
		      local after
		      after=$($GIT_CMD rev-parse HEAD)
		      [[ "$before" != "$after" ]] && CLONE_CHANGED=1
		  fi
	  fi
	  set -e
      if [ $result -ne 0 ]; then
         echo -e "   - ${NORMAL}${RED}✗ Repository '$repo_url' failed to update.${NORMAL}"
		 cat /tmp/leyden-perf-test-clone-$$.log
      else 
         echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Repository '$repo_url' updated.${NORMAL}${CLREOL}"
      fi
      popd > /dev/null
    fi
	return $result
}

# Compiles a Maven application located in TEST_TEST_CACHE/<repository>.
# Output will only be shown if the build fails.
# Arguments:
#   repository - (optional) repository name (used for folder name under TEST_TEST_CACHE, default: "repo")
#   opts       - additional options to pass to Maven
# Variables used:
#   TEST_TEST_CACHE - cache directory for the current test
# Returns:
#   0 if the application was compiled successfully, non-zero otherwise.
function compile_maven() {
    local repository=${1:-repo}
    local opts=${2:-}

    echo "   - Compiling application '$repository'..."
	set +e
    if pushd "${TEST_TEST_CACHE}/$repository" > /tmp/leyden-perf-test-build-$$.log 2>&1; then
		local repo="${TEST_CACHE_DIR}/_mvn_repo"
	    ./mvnw deploy -s "${TEST_DIR}/local-settings.xml" "-Dperf.test.repo=${repo}" "-DaltDeploymentRepository=local-repo::default::file:${repo}" -DskipTests $opts > /tmp/leyden-perf-test-build-$$.log 2>&1
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

# Copies build artifacts from a repository to a destination folder.
# Note: With the new cache-based model, this function is no longer called during setup.
# Arguments:
#   repository - repository name (used for folder name under TEST_TEST_CACHE)
#   subfolder  - subfolder under TEST_TEST_CACHE/<repository> where artifacts will be copied
#   artifacts  - list of files/folders (relative to TEST_TEST_CACHE/<repository>) to copy
# Variables used:
#   TEST_TEST_CACHE - cache directory for the current test
# Returns:
#   0 if the artifacts were copied successfully, non-zero otherwise.
function copy_build_artifacts() {
	local repository=$1
	local subfolder=$2
	local artifacts=( "${@:3}" )

	local dest="${TEST_TEST_CACHE}/$repository/$subfolder"
	echo "   - Copying build artifacts for '$repository'..."
	rm -rf "${dest:?}"
	mkdir -p "$dest"
	pushd "$TEST_TEST_CACHE/$repository" > /dev/null
	cp -a "${artifacts[@]}" "$dest"
	popd > /dev/null
	echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Build artifacts for '$repository' copied.${NORMAL}${CLREOL}"
}

# Ensures that the specified JDK is available and set as active.
# Arguments:
#   version - JDK to activate (either version number or path to JAVA_HOME)
# Variables used:
#   TEST_DIR - Root directory of leyden-perf-test project
function require_java() {
	local version=$1
	echo "   - Ensuring Java $version is available..."
	if [[ $1 =~ ^[0-9]+\+?$ ]]; then
		eval "$("${TEST_DIR}"/jbang jdk env "$version")"
	else
		export JAVA_HOME=$version
		export PATH="${JAVA_HOME}/bin:${PATH}"
	fi
	echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Java $version set as active.${NORMAL}${CLREOL}"
}
