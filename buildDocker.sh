#!/usr/bin/env bash

set -e

setup_echo_colours() {
  # Exit the script on any error
  set -e

  # shellcheck disable=SC2034
  if [ "${MONOCHROME}" = true ]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    BLUE2=''
    DGREY=''
    NC='' # No Colour
  else 
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[1;34m'
    BLUE2='\033[1;34m'
    DGREY='\e[90m'
    NC='\033[0m' # No Colour
  fi
}

debug_value() {
  local name="$1"; shift
  local value="$1"; shift
  
  if [ "${IS_DEBUG}" = true ]; then
    echo -e "${DGREY}DEBUG ${name}: ${value}${NC}"
  fi
}

debug() {
  local str="$1"; shift
  
  if [ "${IS_DEBUG}" = true ]; then
    echo -e "${DGREY}DEBUG ${str}${NC}"
  fi
}

main() {
  IS_DEBUG=false
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  DOCKER_IMAGE_TAG="local-SNAPSHOT"
  DOCKER_IMAGE="at055612/lmdb-testbed:${DOCKER_IMAGE_TAG}"

  local arg1="$1";

  setup_echo_colours

  pushd "${SCRIPT_DIR}" > /dev/null

  ./gradlew clean build shadowJar

  cp ./build/libs/lmdbjava-testbed-all.jar ./docker/build/

  docker build \
    --tag "${DOCKER_IMAGE}" \
    ./docker

  if [[ "${arg1}" = "run" ]]; then
    echo -e "${GREEN}Running image ${BLUE}${DOCKER_IMAGE}${NC}"

    docker run "${DOCKER_IMAGE}"
  elif [[ "${arg1}" = "bash" ]]; then
    docker run -it --entrypoint /bin/bash "${DOCKER_IMAGE}"
  fi
}

main "$@"
