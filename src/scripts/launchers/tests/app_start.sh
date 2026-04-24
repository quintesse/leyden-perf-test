#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
f="${TEST_SUITE_DIR}/shared-vars.sh"; [[ -f "$f" ]] && source "$f"
f="${TEST_TEST_DIR}/shared-vars.sh"; [[ -f "$f" ]] && source "$f"

if [[ -z "${1:-}" ]]; then
    echo "Error: [$0] No script path provided."
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "Error: [$0] script '$1' not found or is not a regular file."
    exit 1
elif [[ ! -r "$1" ]]; then
    echo "Error: [$0] script '$1' is not readable."
    exit 1
fi

source "$1" "${@:2}"
