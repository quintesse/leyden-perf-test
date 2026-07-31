#!/bin/bash

# Hardware tweaks functions for performance testing
# These functions can be used by both hwtweaked-run and qDup

set -euo pipefail

# Check if all required tools are available
check_hwtweak_requirements() {
	local missing=0
	
	if ! command -v cpupower >/dev/null 2>&1; then
		echo "Error: cpupower not found. Please install it." >&2
		missing=1
	fi
	
	if ! command -v taskset >/dev/null 2>&1; then
		echo "Error: taskset not found. Please install it." >&2
		missing=1
	fi
	
	if ! command -v perf >/dev/null 2>&1; then
		echo "Error: perf not found. Please install it." >&2
		missing=1
	fi
	
	return $missing
}

# Detect CPU type and frequencies
detect_cpu_info() {
	# Detect if Intel CPU
	if [[ -z "${IS_INTEL:-}" ]]; then
		CPU_INFO=$(lscpu -p=MODELNAME 2>/dev/null || echo "")
		if grep -iq "Intel(R)" <<< "$CPU_INFO"; then
			export IS_INTEL=true
		else
			export IS_INTEL=false
		fi
	fi
	
	# Auto-detect CPU frequencies if not set
	if [[ -z "${MIN_FREQ:-}" || -z "${MAX_FREQ:-}" ]]; then
		IFS=" " read -r MIN_FREQ MAX_FREQ <<< "$(cpupower frequency-info -l 2>/dev/null | tail -n 1 || echo '')"
		if [[ -z "${MIN_FREQ}" || -z "${MAX_FREQ}" ]]; then
			echo "Error: Could not auto-detect CPU frequencies. Please set MIN_FREQ and MAX_FREQ." >&2
			return 1
		fi
		export MIN_FREQ
		export MAX_FREQ
	fi
	
	return 0
}

# Apply hardware tweaks for performance testing
apply_hardware_tweaks() {
	local test_freq="${TEST_FREQ:-${MAX_FREQ}}"
	
	echo "Applying hardware tweaks for performance testing..."
	
	# Disable turbo boost
	echo "  - Disabling turbo boost..."
	if [[ "${IS_INTEL}" == "true" ]]; then
		echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo >/dev/null 2>&1 || {
			echo "    Warning: Could not disable turbo boost" >&2
		}
	else
		sudo cpupower set --turbo-boost 0 >/dev/null 2>&1 || {
			echo "    Warning: Could not disable turbo boost" >&2
		}
	fi
	
	# Set constant CPU frequency
	echo "  - Setting constant CPU frequency to ${test_freq}..."
	sudo cpupower frequency-set --min "${test_freq}" >/dev/null 2>&1 || {
		echo "    Warning: Could not set minimum CPU frequency" >&2
	}
	sudo cpupower frequency-set --max "${test_freq}" >/dev/null 2>&1 || {
		echo "    Warning: Could not set maximum CPU frequency" >&2
	}
	
	# Clear IO operations
	echo "  - Clearing IO operations..."
	sudo sync 2>&1 || {
		echo "    Warning: Could not sync filesystems" >&2
	}
	
	# Drop caches
	echo "  - Dropping caches..."
	echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null 2>&1 || {
		echo "    Warning: Could not drop caches" >&2
	}
	
	# Clear swap
	echo "  - Clearing swap..."
	sudo swapoff -a 2>&1 && sudo swapon -a 2>&1 || {
		echo "    Warning: Could not clear swap" >&2
	}
	
	# Assign CPUs to current process if TEST_FRAMEWORK_CPUS is set
	if [[ -n "${TEST_FRAMEWORK_CPUS:-}" ]]; then
		echo "  - Assigning CPUs ${TEST_FRAMEWORK_CPUS} to current process..."
		taskset -cp "${TEST_FRAMEWORK_CPUS}" $$ >/dev/null 2>&1 || {
			echo "    Warning: Could not assign CPUs" >&2
		}
	fi
	
	echo "Hardware tweaks applied successfully"
}

# Restore hardware settings to normal
restore_hardware_tweaks() {
	echo "Restoring hardware settings..."
	
	# Restore CPU frequency
	echo "  - Restoring CPU frequency..."
	sudo cpupower frequency-set --min "${MIN_FREQ}" >/dev/null 2>&1 || {
		echo "    Warning: Could not restore minimum CPU frequency" >&2
	}
	sudo cpupower frequency-set --max "${MAX_FREQ}" >/dev/null 2>&1 || {
		echo "    Warning: Could not restore maximum CPU frequency" >&2
	}
	
	# Re-enable turbo boost
	echo "  - Re-enabling turbo boost..."
	if [[ "${IS_INTEL}" == "true" ]]; then
		echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo >/dev/null 2>&1 || {
			echo "    Warning: Could not re-enable turbo boost" >&2
		}
	else
		sudo cpupower set --turbo-boost 1 >/dev/null 2>&1 || {
			echo "    Warning: Could not re-enable turbo boost" >&2
		}
	fi
	
	echo "Hardware settings restored"
}
