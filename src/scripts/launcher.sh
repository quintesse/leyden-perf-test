#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
if [[ -n "${TEST_SUITE_DIR:-}" ]]; then
    f="${TEST_SUITE_DIR}/shared-vars.sh"
    [[ -f "$f" ]] && source "$f"
fi

if [[ -z "${1:-}" ]]; then
    echo "Error: [$0] No script path provided."
    exit 1
fi

script_path=$1
command_name=${2:-}
command_args=("${@:3}")

if [[ ! -f "${script_path}" ]]; then
    echo "Error: [$0] script '${script_path}' not found or is not a regular file."
    exit 1
elif [[ ! -r "${script_path}" ]]; then
    echo "Error: [$0] script '${script_path}' is not readable."
    exit 1
fi

source "${script_path}" "${command_args[@]}"

if [[ -n "${command_name}" ]] && declare -F "${command_name}" > /dev/null; then
    "${command_name}" "${command_args[@]}"
fi
