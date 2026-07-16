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
		index($0, "Setting up infrastructure for test: " test_id " ...") { capture = 1 }
		capture { print }
		index($0, "Stopping infrastructure for test: " test_id " ...") { stop_seen = 1 }
		stop_seen && index($0, ": Done.") { exit }
	' "${log_file}" > "${block_file}"
}

assert_mapping_for_test() {
	local test_id=$1
	local expected_prefix=$2
	shift 2
	local forbidden_prefixes=("$@")

	local block_file="${tmp_dir}/${test_id//\//-}.log"
	extract_test_block "${test_id}" "${block_file}"

	if [[ ! -s "${block_file}" ]]; then
		echo "Failed to capture output block for ${test_id}."
		echo "--- Full output ---"
		cat "${log_file}"
		exit 1
	fi

	local action_regex="(app_setup|app_start|app_stop|infra_setup|infra_start|infra_stop)"
	local expected_count
	expected_count=$(grep -Ec "^${expected_prefix} ${action_regex} action$" "${block_file}" || true)
	if [[ ${expected_count} -ne 6 ]]; then
		echo "Expected 6 '${expected_prefix}' action lines for ${test_id}, got ${expected_count}."
		echo "--- Extracted block (${test_id}) ---"
		cat "${block_file}"
		exit 1
	fi

	local forbidden
	for forbidden in "${forbidden_prefixes[@]}"; do
		if grep -Eq "^${forbidden} ${action_regex} action$" "${block_file}"; then
			echo "Found unexpected '${forbidden}' action lines for ${test_id}."
			echo "--- Extracted block (${test_id}) ---"
			cat "${block_file}"
			exit 1
		fi
	done
}

cd "${repo_root}"

./run test -j 25 -d dummy -s normal -T tests-dummy all -o "${out_dir}" > "${log_file}" 2>&1

assert_mapping_for_test "dummy/override" "Dummy test" "Dummy suite" "Empty test" "Dummy global"
assert_mapping_for_test "dummy/empty" "Dummy suite" "Dummy test" "Empty test" "Dummy global"
assert_mapping_for_test "empty/override" "Empty test" "Dummy test" "Dummy suite" "Dummy global"
assert_mapping_for_test "empty/empty" "Dummy global" "Dummy test" "Dummy suite" "Empty test"

echo "dummy-output check passed"
