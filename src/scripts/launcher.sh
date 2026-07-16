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

script_paths=()
command_name=
command_args=()

while [[ $# -gt 0 && "$1" != "--" ]]; do
    script_paths+=("$1")
    shift
done

if [[ $# -eq 0 || "$1" != "--" ]]; then
    echo "Error: [$0] Missing '--' separator. Usage: launcher.sh <script1> [<script2> ...] -- <command> [args...]"
    exit 1
fi

shift
command_name=${1:-}
command_args=("${@:2}")

if [[ ${#script_paths[@]} -eq 0 ]]; then
    echo "Error: [$0] No script path provided."
    exit 1
fi

for script_path in "${script_paths[@]}"; do
    if [[ ! -f "${script_path}" ]]; then
        echo "Error: [$0] script '${script_path}' not found or is not a regular file."
        exit 1
    elif [[ ! -r "${script_path}" ]]; then
        echo "Error: [$0] script '${script_path}' is not readable."
        exit 1
    fi
done

for script_path in "${script_paths[@]}"; do
    source "${script_path}" "${command_args[@]}"
done

if [[ -n "${command_name}" ]] && declare -F "${command_name}" > /dev/null; then
    "${command_name}" "${command_args[@]}"
fi
