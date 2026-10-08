#!/bin/bash

# DESCRIPTION=Run tests using qdup.

set -euo pipefail

ctrl_c_qdup() {
	echo ""
	echo "Interrupted by user"
	echo ""
	echo -e "Results: \033[0;32m${total_passed} passed\033[0m, \033[0;31m${total_failed} failed\033[0m"
	exit 130
}

trap ctrl_c_qdup INT

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run test ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -eq 0 ]]; then
	echo "This command runs tests using qdup."
	echo "Usage: ./run qdup [<options>] [<test-suite>/<test-name>]"
	echo ""
	echo "Options:"
	echo "  -H|--hosts <hosts>        Hosts file to use that defines which hosts to run the tests on (default: local)"
	echo "  -t|--tag <tag>            Tag to add to the test results folder name"
	echo "  --jdk-tag <tag>           Additional tag to add to the test results folder name indicating the JDK variant"
	echo "  -o|--output <path>        Path to the output folder where test results will be stored (default: ./test-results/test-run-<timestamp>)"
	echo "  -j|--java <versions>      Comma-separated list of Java versions to use for the tests (eg. 8,11,17)."
	echo "  -d|--driver <driver>      Test driver to use (default: oha)"
	echo "  -s|--strategy <strategy>  Test strategy to use (can be specified multiple times, comma-separated)."
	echo "  -P|--profile <profile>    Test profile to use (can be specified multiple times)"
	echo "  --hw-tweaks               Enable hardware tweaks on apphost for better performance measurements (requires sudo)"
	echo "  -C|--catalog <name>       Name of the tests catalog to use (default: tests)"
	echo ""
	echo "This script can be used to run tests."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/sharedfuncs.sh
source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

hosts="local"
resultTag=""
jdkTag=""
outputPath=""
javaVersions=()
strategies=()
profiles=()
testsCatalog="tests"
enable_hw_tweaks=false
enable_dry_run=false
export TEST_DRIVER="oha"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -H|--hosts)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Hosts option specified but no value provided."
                exit 4
            fi
            hosts="$1"
            shift
            ;;
        -C|--catalog)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Tests catalog option specified but no value provided."
				exit 4
			fi
			testsCatalog="$1"
			shift
			;;
        -t|--tag)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Tag option specified but no value provided."
                exit 4
            fi
            resultTag="$1"
            shift
            ;;
        --jdk-tag)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Jdk Tag option specified but no value provided."
                exit 4
            fi
            jdkTag="$1"
            shift
            ;;
        -o|--output)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Output option specified but no path provided."
                exit 4
            fi
            outputPath="$1"
            shift
            ;;
        -j|--java)
            shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Java version option specified but no value provided."
				exit 4
			fi
			if [[ -f $1 ]]; then
				IFS=$'\n' read -r -a versions < "$1"
			else
				IFS=',' read -r -a versions <<< "$1"
			fi
			javaVersions+=("${versions[@]}")
			shift
			;;
        -d|--driver)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Driver option specified but no value provided."
				exit 4
			fi
			if [[ ! -f "${TEST_SRC_DIR}/scripts/drivers/$1/driver.sh" ]]; then
				echo "Error: Test driver '$1' does not exist."
				echo "Use './run list-drivers' to see the list of available drivers."
				exit 4
			fi
			TEST_DRIVER="$1"
			shift
			;;
        -s|--strat|--strategy)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Strategy option specified but no value provided."
				exit 4
			fi
			IFS=',' read -r -a strats <<< "$1"
			for strat in "${strats[@]}"; do
				if [[ -f "${TEST_SRC_DIR}/scripts/strategies/$strat/strategy.sh" ]]; then
					strategies+=("$strat")
				else
					echo "Error: Strategy '$strat' does not exist."
					echo "Use './run list-strategies' to see the list of available strategies."
					exit 4
				fi
			done
			shift
			;;
        -P|--profile)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Warn: Profile option specified but no value provided."
			else
				# Parse comma-separated profiles
				if ! parse_profiles "$1" profiles; then
					exit 4
				fi
			fi
			shift
			;;
        --hw-tweaks)
			enable_hw_tweaks=true
			shift
			;;
        --dry-run)
			enable_dry_run=true
			shift
			;;
        -*)
            echo "Error: Unknown option: $1"
			exit 4
            ;;
        *)
            break
            ;;
    esac
done

export TEST_CATALOG="${testsCatalog}"
export TEST_ROOT_DIR="${TEST_DIR}/${testsCatalog}"

if [[ ${#profiles[@]} -eq 0 && -f "${TEST_DIR}/profiles/default.sh" ]]; then
	profiles=("default")
	echo "Info: Auto-activating 'default' profile"
fi

function run_qdup() {
	local outputPath="${1:-}"
	local strategy="$2"
	local testpat="$3"

	local tests=( $(select_tests "${testpat}") )

	if [[ ${#tests[@]} -eq 0 ]]; then
		echo "Error: No tests match the pattern '${testpat}'."
		return 1
	fi

	local qdupdir="${TEST_SRC_DIR}/qdup"

	local qdup_work_dir="/tmp/qdup-code"
	mkdir -p "${qdup_work_dir}"

	local qdup_cache_dir=$(realpath "./cache")
	mkdir -p "${qdup_cache_dir}"

	export TEST_RUNID="test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}"
	outputPath="${outputPath:-./test-results/${TEST_RUNID}}"
	mkdir -p "${outputPath}"

	# Convert profiles array to comma-separated string for qdup
	local profiles_str=""
	if [[ ${#profiles[@]} -gt 0 ]]; then
		profiles_str=$(IFS=','; echo "${profiles[*]}")
		info "Using profiles: ${profiles_str}"
	fi

	local result=0
	for test in "${tests[@]}"; do
		for javaVersion in "${javaVersions[@]}"; do
			local qdup_states=(
				"-S" "TEST_DIR=${TEST_DIR}"
				"-S" "JAVA_VERSION=${javaVersion}"
				"-S" "TEST_CATALOG=${TEST_CATALOG}"
				"-S" "TEST=${test}"
				"-S" "TEST_RUNID=${TEST_RUNID}"
				"-S" "WORK_DIR=${qdup_work_dir}"
				"-S" "CACHE_DIR=${qdup_cache_dir}"
				"-S" "RESULT_DIR=${outputPath}"
				"-S" "PROFILES=${profiles_str}"
				"-S" "TEST_DRIVER=${TEST_DRIVER}"
			)

			if [[ "${enable_hw_tweaks}" == "true" ]]; then
				qdup_states+=("-S" "ENABLE_HW_TWEAKS=true")
				info "Hardware tweaks enabled for apphost"
			fi

			local scripts_file="${TEST_SRC_DIR}/qdup/scripts.yml"
			local strategy_file="${TEST_SRC_DIR}/qdup/test-${strategy}.yml"

			local hosts_file
			if [[ "${hosts}" == /* || "${hosts}" == .* ]]; then
				# Path to a hosts yml file
				hosts_file="${hosts}"
			else
				# Name of a hosts file in the ../hosts directory
				hosts_file="${TEST_SRC_DIR}/qdup/hosts/${hosts}.yml"
			fi
	
			info "${BOLD}Running test: ${test} with Java version: ${javaVersion}${NORMAL}"
			info "Command: $qdupdir/bin/qdup" "${scripts_file}" "${hosts_file}" "${strategy_file}" -B "${outputPath}" "${qdup_states[@]}"
			if [[ "${enable_dry_run}" != "true" ]] && ! "$qdupdir/bin/qdup" "${scripts_file}" "${hosts_file}" "${strategy_file}" -B "${outputPath}" "${qdup_states[@]}"; then
				fail "Test failed: ${test}"
				result=1
				(( total_failed++ )) || true
			else
				success "Test passed: ${test}"
				(( total_passed++ )) || true
			fi
		done
	done
	return $result
}

if [[ ${#strategies[@]} -eq 0 ]]; then
	strategies=("normal")
fi

if [[ ${#javaVersions[@]} -eq 0 ]]; then
	echo "Error: No Java versions specified."
	exit 4
fi

total_passed=0
total_failed=0

for strategy in "${strategies[@]}"; do
	info "Using strategy: ${strategy}"
	run_qdup "${outputPath}" "${strategy}" "${1:-all}" || true
done

echo ""
echo -e "Results: \033[0;32m${total_passed} passed\033[0m, \033[0;31m${total_failed} failed\033[0m"
