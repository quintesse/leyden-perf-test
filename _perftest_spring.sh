#!/bin/bash

echo Running fake perf tests...
oha -n 10000 --urls-from-file urls.txt -o spring.out

