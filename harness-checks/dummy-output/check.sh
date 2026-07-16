#!/bin/bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
repo_root=$(cd -- "${script_dir}/../.." &> /dev/null && pwd)

tmp_dir=$(mktemp -d)
log_file="${tmp_dir}/run.log"
out_dir="${tmp_dir}/results"

cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

extract_test_block() {
	local test_id=$1
	local block_file=$2

	awk -v test_id="${test_id}" '
		index($0, "Running infra_setup for test: " test_id " ...") { capture = 1 }
		capture { print }
		index($0, "Running infra_stop for test: " test_id " ...") { stop_seen = 1 }
		stop_seen && index($0, ": Done.") { exit }
	' "${log_file}" > "${block_file}"
}

extract_action_lines() {
	local input_file=$1
	local output_file=$2
	grep -E '^(Dummy|Empty) (global|suite|test) (infra_setup|app_setup|driver_setup|infra_start|driver_prime|app_start|driver_run|app_stop|infra_stop) action$' "${input_file}" > "${output_file}"
}

assert_lines_exact() {
	local actual_file=$1
	shift
	local expected_lines=("$@")

	mapfile -t actual_lines < "${actual_file}"
	if [[ ${#actual_lines[@]} -ne ${#expected_lines[@]} ]]; then
		echo "Expected ${#expected_lines[@]} action lines, got ${#actual_lines[@]}."
		echo "--- Actual lines ---"
		cat "${actual_file}"
		exit 1
	fi

	local i
	for i in "${!expected_lines[@]}"; do
		if [[ "${actual_lines[i]}" != "${expected_lines[i]}" ]]; then
			echo "Action line ${i} did not match."
			echo "Expected: ${expected_lines[i]}"
			echo "Actual:   ${actual_lines[i]}"
			echo "--- Actual lines ---"
			cat "${actual_file}"
			exit 1
		fi
	done
}

assert_mapping_for_test() {
	local test_id=$1
	local expected_prefix=$2
	shift 2
	local expected_lines=("$@")

	local block_file="${tmp_dir}/${test_id//\//-}.log"
	extract_test_block "${test_id}" "${block_file}"

	if [[ ! -s "${block_file}" ]]; then
		echo "Failed to capture output block for ${test_id}."
		echo "--- Full output ---"
		cat "${log_file}"
		exit 1
	fi

	local action_lines_file="${tmp_dir}/${test_id//\//-}.actions"
	extract_action_lines "${block_file}" "${action_lines_file}"
	assert_lines_exact "${action_lines_file}" "${expected_lines[@]}"
}

cd "${repo_root}"

./run test -j 25 -d dummy -s normal -T tests-dummy all -o "${out_dir}" > "${log_file}" 2>&1

assert_mapping_for_test "dummy/override" "Dummy test" \
	"Dummy test infra_setup action" \
	"Dummy test app_setup action" \
	"Dummy test driver_setup action" \
	"Dummy test infra_start action" \
	"Dummy test driver_prime action" \
	"Dummy test app_start action" \
	"Dummy test driver_run action" \
	"Dummy test app_stop action" \
	"Dummy test infra_stop action"

assert_mapping_for_test "dummy/empty" "Dummy suite" \
	"Dummy suite infra_setup action" \
	"Dummy suite app_setup action" \
	"Dummy suite driver_setup action" \
	"Dummy suite infra_start action" \
	"Dummy suite driver_prime action" \
	"Dummy suite app_start action" \
	"Dummy suite driver_run action" \
	"Dummy suite app_stop action" \
	"Dummy suite infra_stop action"

assert_mapping_for_test "empty/override" "Empty test" \
	"Empty test infra_setup action" \
	"Empty test app_setup action" \
	"Empty test driver_setup action" \
	"Empty test infra_start action" \
	"Empty test driver_prime action" \
	"Empty test app_start action" \
	"Empty test driver_run action" \
	"Empty test app_stop action" \
	"Empty test infra_stop action"

assert_mapping_for_test "empty/empty" "Dummy global" \
	"Dummy global infra_setup action" \
	"Dummy global app_setup action" \
	"Dummy global driver_setup action" \
	"Dummy global infra_start action" \
	"Dummy global driver_prime action" \
	"Dummy global app_start action" \
	"Dummy global driver_run action" \
	"Dummy global app_stop action" \
	"Dummy global infra_stop action"

echo "dummy-output check passed"
