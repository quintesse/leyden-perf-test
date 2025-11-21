#!/bin/bash

echo -e "\033[0;91m\033[47m                                               \033[0m"
echo -e "\033[0;91m\033[47m   ****************************************    \033[0m"
echo -e "\033[0;91m\033[47m   **** YOU SHOULD NOT USE THIS SCRIPT ****    \033[0m"
echo -e "\033[0;91m\033[47m   ****************************************    \033[0m"
echo -e "\033[0;91m\033[47m                                               \033[0m"
echo ""
echo "This script tries to tweak your hardware to make tests less flaky, but still, this is NOT the way to run proper performance tests. Results here cannot be used to complain about performance."
echo ""

source hardware-tweaks.conf

echo "Requirements check:"

if [ $HARDWARE_CONFIGURED == false ]; then
  echo -e "    - \033[0;31mMake sure you edit the hardware-tweaks.conf file before you run this\033[0m"
  exit 1; 
else
    echo -e "   - \033[0;32m✓ configuration\033[0m"
fi


if ! command -v cpupower >/dev/null 2>&1
then
    echo -e "   - \033[0;31m✗ cpupower: Command not found, please install it\033[0m"
    exit 1
else
    echo -e "   - \033[0;32m✓ cpupower\033[0m"
fi

if ! command -v taskset >/dev/null 2>&1
then
    echo -e "   - \033[0;31m✗ taskset: Command not found, please install it\033[0m"
    exit 1
else
    echo -e "   - \033[0;32m✓ taskset\033[0m"
fi

if ! command -v perf >/dev/null 2>&1
then
    echo -e "   - \033[0;31m✗ perf: Command not found, please install it\033[0m"
    exit 1
else
    echo -e "   - \033[0;32m✓ perf \033[0m"
fi

echo "This command will ask you for your sudo password to tweak the hardware."
echo "It will restore back all the hardware configuration, but it may fail. Be careful using this command."

echo "Disabling turbo boost"
if [ $IS_INTEL == true ]; then
  echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
else
  sudo cpupower set --turbo-boost 0
fi

echo "Setting a constant CPU frequency"
sudo cpupower frequency-set --min $TEST_FREQ --max $TEST_FREQ

echo "Clearing IO Operations"
sudo sync

echo "Clearing Swap"
echo 3 | sudo tee /proc/sys/vm/drop_caches
sudo swapoff -a && sudo swapon -a

# Launch run with all the configuration options
./run.sh "$@"

echo "Trying to restore the hardware configuration"
echo "Free CPU frequency"
sudo cpupower frequency-set --min $MIN_FREQ --max $MAX_FREQ

echo "Re-enabling turbo boost"
if [ $IS_INTEL == true ]; then
  echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
else
  sudo cpupower set --turbo-boost 1
fi

