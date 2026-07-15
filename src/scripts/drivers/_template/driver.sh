#!/bin/bash

set -euo pipefail

# This script can make use of the following env vars:
# - TEST_DRIVER_RATE_LIMIT env var to set rate limit (requests per second)
# - TEST_PERF_CNT env var to set number of requests

setup() {
    # ... put your code to install/setup the test driver here ...
    :
}

prepare() {
    # ... Perform any work required before the driver is run ...
    # This action is optional and can be removed if not needed
    :
}

run() {
    # ... put your code to run (drive) performance tests here ...
    :
}
