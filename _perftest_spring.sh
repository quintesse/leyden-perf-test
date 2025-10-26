#!/bin/bash

echo Running some warm-up tests...
oha -n 10 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

sleep 5

echo Running perf tests...
oha -n 10000 -u ms --no-tui --urls-from-file urls.txt -o ${TEST_OUT_DIR:-.}/spring-test.out
