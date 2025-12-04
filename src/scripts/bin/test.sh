#!/bin/bash

# DESCRIPTION=Runs tests.

set -euo pipefail

trap ctrl_c INT

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run test ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -eq 0 ]]; then
	echo "This command runs tests."
	echo "Usage: ./run test [<options>] [<test-suite>/<test-name>]"
	echo ""
	echo "Options:"
	echo "  --aot <never|always|only>    Enable AOT compilation for tests (default: always)"
	echo "  -t|--tag <tag>               Tag to add to the test results folder name"
	echo "  --jdk-tag <tag>              Additional tag to add to the test results folder name indicating the JDK variant"
	echo "  -o|--output <path>           Path to the output folder where test results will be stored (default: ./test-results/test-run-<timestamp>)"
	echo "  -j|--java <versions>         Comma-separated list of Java versions to use for the tests (eg. 8,11,17)."
	echo "  -d|--driver <driver>         Test driver to use (default: oha)"
	echo "  -P|--profile <profile>       Test profile to use (can be specified multiple times)"
	echo ""
	echo "This script can be used to run tests."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh
source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh

resultTag=""
jdkTag=""
outputPath=""
javaVersions=()
strategies=()
profiles=()
export TEST_DRIVER="oha"

while [[ $# -gt 0 ]]; do
    case "$1" in
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
			IFS=',' read -r -a versions <<< "$1"
			javaVersions+=("${versions[@]}")
			shift
			;;
        -d|--driver)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Driver option specified but no value provided."
				exit 4
			fi
			if [[ ! -f "${TEST_SRC_DIR}/scripts/drivers/$1.sh" ]]; then
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
				if [[ -f "${TEST_SRC_DIR}/scripts/strategies/$strat.sh" ]]; then
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

export TEST_OUT_BASE=${outputPath:-./test-results/test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}}
mkdir -p "${TEST_OUT_BASE}"

testPat=${1:-all}

if [[ ${#strategies[@]} -eq 0 ]]; then
	strategies=("normal" "aot")
fi

if [[ ${#profiles[@]} -eq 0 && -f "${TEST_DIR}/profiles/default.sh" ]]; then
	profiles=("default")
fi

{
	"${TEST_DIR}/run" list "${testPat}"
	echo "Test driver: ${TEST_DRIVER}"
	echo "Selected JDKs: ${javaVersions[*]}"
	echo "Selected strategies: ${strategies[*]}"
	echo "Activated profiles: ${profiles[*]}"
} > "${TEST_OUT_BASE}/test-run-info.txt"

export TEST_OUT_DIR
export TEST_TEST_RUNID

for profile in "${profiles[@]}"; do
	echo "   - Applying profile: ${profile}"
	source "${TEST_DIR}/profiles/${profile}.sh"
done

echo "   - Selected java versions ${javaVersions[*]}"
for javaVersion in "${javaVersions[@]}"; do
	echo "   - Running tests with Java version ${javaVersion}"
	export TEST_APP_JAVA=${javaVersion}
	
	for strategy in "${strategies[@]}"; do
		echo "   - Using strategy: ${strategy}"
		TEST_OUT_DIR=${TEST_OUT_BASE}/j${javaVersion}-${strategy}${jdkTag:+-$jdkTag}
		mkdir -p "${TEST_OUT_DIR}"
		echo "   - Created test output folder ${TEST_OUT_DIR}"
		source "${TEST_SRC_DIR}/scripts/strategies/${strategy}.sh"
	done
done
