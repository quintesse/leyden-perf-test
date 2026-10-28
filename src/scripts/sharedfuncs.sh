#!/bin/bash

set -euo pipefail

# Shared utility functions used across multiple scripts

function info() {
    echo -e "   - $*${NORMAL}"
}

function success() {
    echo -e "   ${GREEN}✓${NORMAL} $*${NORMAL}"
}

function fail() {
    echo -e "   ${RED}✗${NORMAL} $*${NORMAL}"
}

# Parse comma-separated profile names and validate they exist
# Usage: parse_profiles "profile1,profile2" profiles_array_name
# The second argument is the name of the array variable to populate
function parse_profiles() {
    local profile_string="$1"
    local -n result_array="$2"
    
    if [[ -z "${profile_string}" ]]; then
        return 0
    fi
    
    # Split comma-separated profiles
    IFS=',' read -ra profile_list <<< "${profile_string}"
    
    # Validate and add each profile
    for profile in "${profile_list[@]}"; do
        # Trim whitespace
        profile=$(echo "${profile}" | xargs)
        
        if [[ -z "${profile}" ]]; then
            continue
        fi
        
        if [[ ! -f "${TEST_DIR}/profiles/${profile}.sh" ]]; then
            echo "Error: Profile '${profile}' does not exist."
            echo "Use './run list-profiles' to see the list of available profiles."
            return 1
        fi
        
        result_array+=("${profile}")
    done
    
    return 0
}

function run_sudo() {
    if [[ $EUID -ne 0 ]]; then
        local sudo_args
        if [[ -n "${SUDO_ASKPASS:-}" ]]; then
            sudo_args="-A"
        else
            sudo_args="-n"
        fi
        sudo ${sudo_args} "$@"
    else
        "$@"
    fi
}

# Ensures that the specified JDK is available and set as active.
# If no version is specified it will ensure the globally defined Java
# version will be used. And if that is not set it will do nothing.
# Arguments:
#   version - JDK to activate (either version number or path to JAVA_HOME)
#              If not specified, defaults to TEST_APP_JAVA if set.
# Variables used:
#   TEST_DIR - Root directory of leyden-perf-test project
#   TEST_APP_JAVA - Globally set Java version for the application
function require_java() {
	local version=${1:-${TEST_APP_JAVA:-}}
	if [[ -z "$version" ]]; then
		return 0
	fi
	info "Ensuring Java $version is available..."
	if [[ "$version" =~ ^[0-9]+\+?$ ]]; then
		eval "$("${TEST_DIR}"/jbang jdk env "$version")"
	else
		export JAVA_HOME=$version
		export PATH="${JAVA_HOME}/bin:${PATH}"
	fi
	success "Java $version set as active"
}
