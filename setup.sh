#!/bin/bash

clone() {
    echo "Clone Spring Quarkus Performance Comparison repository"
    git clone --depth 1 https://github.com/quarkusio/spring-quarkus-perf-comparison.git
}

compile() {
    echo "Compile application"
    pushd spring-quarkus-perf-comparison
    ./mvnw package -Dquarkus.hibernate-orm.sql-load-script=import.sql -DskipTests
    popd
}

if ! command -v oha >/dev/null 2>&1
then
    echo "   - ✗ oha   : Command not found, please install it, see https://github.com/hatoo/oha"
else
    echo "   - ✓ oha   : Command is installed."
fi

clone
compile
