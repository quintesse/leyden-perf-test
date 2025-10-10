#!/bin/bash

# Compile Spring Boot Petclinic
pushd spring-petclinic
./mvnw clean package -DskipTests
popd

# Compile Quarkus Petclinic
pushd quarkus-petclinic
./mvnw clean package -DskipTests -Dnet.bytebuddy.experimental -Dquarkus.package.jar.type=uber-jar
popd

