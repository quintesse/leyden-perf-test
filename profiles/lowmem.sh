#!/bin/bash

# DESCRIPTION=Set Java options for low memory usage.

set -aeuo pipefail

TEST_JAVA_OPTS="-Xms128m -Xmx256m"
