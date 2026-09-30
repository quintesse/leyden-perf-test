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
      info "Cloning repository '$repo_url'..."
	  local result=0
      $GIT_CMD clone --quiet --depth 1 "$repo_url" "${TEST_TEST_CACHE}/$repository" > /tmp/leyden-perf-test-clone-$$.log 2>&1 || result=$?
      if [ $result -ne 0 ]; then
         fail "Repository '$repo_url' failed to clone"
      else
         CLONE_CHANGED=1
         success "Repository '$repo_url' cloned"
      fi
    else 
      info "Updating repository '$repo_url'..."
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
         fail "Repository '$repo_url' failed to update"
		 cat /tmp/leyden-perf-test-clone-$$.log
      else 
         success "Repository '$repo_url' updated"
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
    local opts=${2:--DskipTests}

    info "Compiling application '$repository'..."
	set +e
    if pushd "${TEST_TEST_CACHE}/$repository" > /tmp/leyden-perf-test-build-$$.log 2>&1; then
		local repo="${TEST_CACHE_DIR}/_mvn_repo"
	    ./mvnw deploy -s "${TEST_DIR}/local-settings.xml" "-Dperf.test.repo=${repo}" "-DaltDeploymentRepository=local-repo::default::file:${repo}" $opts > /tmp/leyden-perf-test-build-$$.log 2>&1
	fi
    local result=$?
	set -e
    if [ $result -ne 0 ]; then
       fail "'$repository' failed to build"
	   cat /tmp/leyden-perf-test-build-$$.log
    else 
       success "'$repository' built"
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
	info "Copying build artifacts for '$repository'..."
	rm -rf "${dest:?}"
	mkdir -p "$dest"
	pushd "$TEST_TEST_CACHE/$repository" > /dev/null
	cp -a "${artifacts[@]}" "$dest"
	popd > /dev/null
	success "Build artifacts for '$repository' copied"
}

# Ensures that the specified JDK is available and set as active.
# Arguments:
#   version - JDK to activate (either version number or path to JAVA_HOME)
# Variables used:
#   TEST_DIR - Root directory of leyden-perf-test project
function require_java() {
	local version=$1
	info "Ensuring Java $version is available..."
	if [[ $1 =~ ^[0-9]+\+?$ ]]; then
		eval "$("${TEST_DIR}"/jbang jdk env "$version")"
	else
		export JAVA_HOME=$version
		export PATH="${JAVA_HOME}/bin:${PATH}"
	fi
	success "Java $version set as active"
}
