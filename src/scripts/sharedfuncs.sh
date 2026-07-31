#!/bin/bash

# Shared utility functions used across multiple scripts

# Parse comma-separated profile names and validate they exist
# Usage: parse_profiles "profile1,profile2" profiles_array_name
# The second argument is the name of the array variable to populate
parse_profiles() {
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
