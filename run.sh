#!/bin/bash
set -euo pipefail

export TEST_OUT_DIR=./test-results/test-run-$(date +%Y%m%d-%H%M%S)
mkdir -p ${TEST_OUT_DIR}

./_test.sh
