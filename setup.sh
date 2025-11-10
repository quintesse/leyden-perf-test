#!/bin/bash

clone() {
    repository="spring-quarkus-perf-comparison"
    if [ ! -d $repository ]; then
      echo "Clone Spring Quarkus Performance Comparison repository"
      git clone --depth 1 https://github.com/quarkusio/spring-quarkus-perf-comparison.git 
      if [ $? -ne 0 ]; then
         echo -e "   - \033[0;31m✗ "$repository" failed to clone.\033[0m"
      else 
         echo -e "   - \033[0;32m✓ "$repository" cloned.\033[0m"
      fi
    else 
      cd $repository
      git reset HEAD --hard >> /dev/null
      git pull >> /dev/null 
      if [ $? -ne 0 ]; then
         echo -e "   - \033[0;31m✗ "$repository" failed to update.\033[0m"
      else 
         echo -e "   - \033[0;32m✓ "$repository" updated.\033[0m"
      fi
      cd ..
    fi
}

compile() {
    echo "Compile application"
    repository="spring-quarkus-perf-comparison"
    pushd $repository
    ./mvnw package -Dquarkus.hibernate-orm.sql-load-script=import.sql -DskipTests
    if [ $? -ne 0 ]; then
       echo -e "   - \033[0;31m✗ "$repository" failed to build.\033[0m"
    else 
       echo -e "   - \033[0;32m✓ "$repository" built.\033[0m"
    fi
    popd
}

if ! command -v oha >/dev/null 2>&1
then
    echo -e "   - \033[0;31m✗ oha   : Command not found, please install it, see https://github.com/hatoo/oha\033[0m"
else
    echo -e "   - \033[0;32m✓ oha   : Command is installed.\033[0m"
fi

clone
compile
