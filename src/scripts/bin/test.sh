#!/bin/bash

# DESCRIPTION=Run tests.

set -euo pipefail

ctrl_c() {
	echo ""
	echo "Interrupted by user"
	if [[ "${HW_TWEAKS_ENABLED:-false}" == "true" ]]; then
		echo "Restoring hardware settings..."
		restore_hardware_tweaks
	fi
	exit 130
}

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
	echo "  -t|--tag <tag>            Tag to add to the test results folder name"
	echo "  --jdk-tag <tag>           Additional tag to add to the test results folder name indicating the JDK variant"
	echo "  -o|--output <path>        Path to the output folder where test results will be stored (default: ./test-results/test-run-<timestamp>)"
	echo "  -j|--java <versions>      Comma-separated list of Java versions to use for the tests (eg. 8,11,17)."
	echo "  -d|--driver <driver>      Test driver to use (default: oha)"
	echo "  -s|--strategy <strategy>  Test strategy to use (can be specified multiple times, comma-separated)."
	echo "  -P|--profile <profile>    Test profile to use (can be specified multiple times)"
	echo "  -T|--tests-root <path>    Path to the test root folder (default: ./tests)"
	echo "  --hw-tweaks               Apply hardware tweaks before running tests (requires sudo, Linux only)"
	echo ""
	echo "This script can be used to run tests."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh
source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SRC_DIR}"/scripts/driverfuncs.sh

resultTag=""
jdkTag=""
outputPath=""
javaVersions=()
strategies=()
profiles=()
testsRootDir="${TEST_DIR}/tests"
export TEST_DRIVER="oha"
HW_TWEAKS_ENABLED=false

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
        -T|--tests-root)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Tests root option specified but no path provided."
				exit 4
			fi
			testsRootDir="$1"
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
        --hw-tweaks)
			HW_TWEAKS_ENABLED=true
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

export TEST_OUT_BASE=${outputPath:-./test-results/test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}}
mkdir -p "${TEST_OUT_BASE}"

testPat=${1:-all}

if [[ ${#strategies[@]} -eq 0 ]]; then
	strategies=("normal" "aot")
fi

if [[ ${#profiles[@]} -eq 0 && -f "${TEST_DIR}/profiles/default.sh" ]]; then
	profiles=("default")
	echo "Info: Auto-activating 'default' profile"
fi

if [[ ${#javaVersions[@]} -eq 0 ]]; then
	echo "Error: No Java versions specified."
	exit 4
fi

# Validate that the test pattern matches at least one test
if ! "${TEST_DIR}/run" list -T "${testsRootDir}" "${testPat}" > /dev/null 2>&1; then
	"${TEST_DIR}/run" list -T "${testsRootDir}" "${testPat}"
	exit 1
fi

{
	"${TEST_DIR}/run" list -T "${testsRootDir}" "${testPat}"
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

if [[ "${HW_TWEAKS_ENABLED}" == "true" ]]; then
	source "${TEST_SRC_DIR}/scripts/hwtweakfuncs.sh"
	
	echo ""
	echo -e "\033[0;91m\033[47m                                               \033[0m"
	echo -e "\033[0;91m\033[47m   ****************************************    \033[0m"
	echo -e "\033[0;91m\033[47m   **** YOU SHOULD NOT USE THIS OPTION ****    \033[0m"
	echo -e "\033[0;91m\033[47m   ****************************************    \033[0m"
	echo -e "\033[0;91m\033[47m                                               \033[0m"
	echo ""
	echo "This option tries to tweak your hardware to make tests less flaky, but still, this is NOT the way to run proper performance tests. Results here cannot be used to complain about performance."
	echo ""
	
	OS=
	case "$(uname -s)" in
		Linux*)	OS=linux;;
		Darwin*) OS=mac;;
		CYGWIN*|MINGW*|MSYS*) OS=windows;;
	esac
	if [ "$OS" != "linux" ]; then
		echo -e "\033[0;31mHardware tweaks are only supported on Linux.\033[0m"
		exit 1
	fi
	
	# Source hardware configuration
	source "${TEST_DIR}/hardware-tweaks.conf"
	
	echo "Requirements check:"
	
	# Check requirements
	if ! check_hwtweak_requirements; then
		exit 1
	fi
	echo -e "   - \033[0;32m✓ All required tools found\033[0m"
	
	# Detect CPU info
	if ! detect_cpu_info; then
		exit 1
	fi
	
	if [[ "${IS_INTEL}" == "true" ]]; then
		echo -e "   - \033[0;32m✓ Detected Intel CPU\033[0m"
	else
		echo -e "   - \033[0;32m✓ Detected non-Intel CPU\033[0m"
	fi
	
	echo -e "   - \033[0;32m✓ Auto-detected MIN_FREQ=$MIN_FREQ, MAX_FREQ=$MAX_FREQ\033[0m"
	
	if [ $HARDWARE_CONFIGURED == false ]; then
		echo -e "\033[0;31mMake sure you edit the hardware-tweaks.conf file before you run this\033[0m"
		exit 1
	else
		echo -e "   - \033[0;32m✓ configuration\033[0m"
	fi
	
	echo -e "${BOLD}This command will ask you for your sudo password to tweak the hardware.${NORMAL}"
	echo -e "${BOLD}It will restore back all the hardware configuration, but it may fail.${NORMAL}"
	echo -e "${BOLD}Be careful using this command.${NORMAL}"
	
	# Apply hardware tweaks
	apply_hardware_tweaks
	echo ""
fi

setup_driver

echo "   - Selected java versions ${javaVersions[*]}"
for javaVersion in "${javaVersions[@]}"; do
	echo "   - Running tests with Java version ${javaVersion}"
	export TEST_APP_JAVA=${javaVersion}
	
	for strategy in "${strategies[@]}"; do
		echo "   - Using strategy: ${strategy}"
		_setup_test_output_dir "j${javaVersion}-${strategy}${jdkTag:+-$jdkTag}" "${outputPath}" "${resultTag}"
		source "${TEST_SRC_DIR}/scripts/strategies/${strategy}/strategy.sh"
	done
done

if [[ "${HW_TWEAKS_ENABLED}" == "true" ]]; then
	echo ""
	echo "Restoring hardware settings..."
	restore_hardware_tweaks
fi
