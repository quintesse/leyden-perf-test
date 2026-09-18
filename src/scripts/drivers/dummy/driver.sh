#!/bin/bash

set -euo pipefail

setup() {
    echo "Dummy driver setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/driver-dummy-${TEST_TEST_RUNID}.txt"
}

prime() {
    echo "Dummy driver prime action"
    echo "prime" >> "${TEST_OUT_DIR:-.}/driver-dummy-${TEST_TEST_RUNID}.txt"
}

run() {
    echo "Dummy driver run action"
    echo "run" >> "${TEST_OUT_DIR:-.}/driver-dummy-${TEST_TEST_RUNID}.txt"
}
