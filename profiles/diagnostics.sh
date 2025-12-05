#!/bin/bash

# DESCRIPTION=Template profile for diagnostics.

set -aeuo pipefail

TEST_LOG_LABEL="class+load=info,aot+resolve*=trace,aot+codecache+exit=debug,"
TEST_JAVA_OPTS="-XX:+PrintCompilation"
