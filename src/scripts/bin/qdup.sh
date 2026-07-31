#!/bin/bash

# DESCRIPTION=Run tests using qdup.

set -euo pipefail

trap ctrl_c INT

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
	echo "  -T|--tests-root <path>    Path to the test root folder (default: ./tests)"
	echo ""
	echo "This script can be used to run tests."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

hosts="local"
resultTag=""
jdkTag=""
outputPath=""
javaVersions=()
strategies=()
profiles=()
testsRootDir="${TEST_DIR}/tests"
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
        -T|--tests-root)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Tests root option specified but no path provided."
				exit 4
			fi
			testsRootDir="$1"
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
				echo "Error: Profile option specified but no value provided."
				exit 4
			fi
			if [[ -f "${TEST_DIR}/profiles/$1.sh" ]]; then
				profiles+=("$1")
			else
				echo "Error: Profile '$1' does not exist."
				echo "Use './run list-profiles' to see the list of available profiles."
				exit 4
			fi
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

export TEST_ROOT_DIR="${testsRootDir}"

if [[ ${#profiles[@]} -eq 0 && -f "${TEST_DIR}/profiles/default.sh" ]]; then
	profiles=("default")
	echo "Info: Auto-activating 'default' profile"
fi

function run_qdup() {
	local strategy="$1"
	local testpat="$2"

	local tests=( $(select_tests "${testpat}") )
	local qdupdir="${TEST_SRC_DIR}/qdup"

	export TEST_OUT_BASE=${outputPath:-/tmp/leyden-perf-test/test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}}
	mkdir -p "${TEST_OUT_BASE}"

	# Build profile arguments to pass to qdup-test
	local profile_args=()
	for profile in "${profiles[@]}"; do
		echo "   - Using profile: ${profile}"
		profile_args+=("-P" "${profile}")
	done

	local result=0
	for test in "${tests[@]}"; do
		for javaVersion in "${javaVersions[@]}"; do
			echo -e "${BOLD}Running test: ${test} with Java version: ${javaVersion}${NORMAL}"
			"$qdupdir/bin/qdup-test" "${hosts}" "${strategy}" "${javaVersion}" "${test}" "${TEST_OUT_BASE}" "${profile_args[@]}"
			if [[ $? -ne 0 ]]; then
				result=1
			fi
		done
	done
	return $result
}

if [[ ${#strategies[@]} -eq 0 ]]; then
	strategies=("normal")
fi

if [[ ${#profiles[@]} -eq 0 && -f "${TEST_DIR}/profiles/default.sh" ]]; then
	profiles=("default")
fi

if [[ ${#javaVersions[@]} -eq 0 ]]; then
	echo "Error: No Java versions specified."
	exit 4
fi

for strategy in "${strategies[@]}"; do
	echo "   - Using strategy: ${strategy}"
	run_qdup "${strategy}" "${1:-all}"
done
