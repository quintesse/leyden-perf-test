#!/bin/bash

source ./_functions.sh

clone() {
    local repository=$1
	local repo_url=$2

    if [[ ! -d $repository ]]; then
      echo "Clone repository '$repository'"
      git clone --depth 1 "$repo_url" "$repository"
      if [ $? -ne 0 ]; then
         echo -e "   - \033[0;31m✗ '$repository' failed to clone.\033[0m"
      else 
         echo -e "   - \033[0;32m✓ '$repository' cloned.\033[0m"
      fi
    else 
      pushd "$repository"
      git reset HEAD --hard >> /dev/null
      git pull >> /dev/null 
      if [ $? -ne 0 ]; then
         echo -e "   - \033[0;31m✗ '$repository' failed to update.\033[0m"
      else 
         echo -e "   - \033[0;32m✓ '$repository' updated.\033[0m"
      fi
      popd
    fi
}

compile() {
    local repository=$1

    echo "Compile application '$repository'"
    pushd "$repository"
    ./mvnw clean package -DskipTests
    if [ $? -ne 0 ]; then
       echo -e "   - \033[0;31m✗ '$repository' failed to build.\033[0m"
    else 
       echo -e "   - \033[0;32m✓ '$repository' built.\033[0m"
    fi
    popd
}

if ! command -v oha >/dev/null 2>&1
then
    echo -e "   - \033[0;31m✗ oha   : Command not found, please install it, see https://github.com/hatoo/oha\033[0m"
else
    echo -e "   - \033[0;32m✓ oha   : Command is installed.\033[0m"
fi

clone "spring-quarkus-perf-comparison" "https://github.com/quarkusio/spring-quarkus-perf-comparison.git"

save_jdk
switch_jdk "21+"

compile "spring-quarkus-perf-comparison"

restore_jdk
