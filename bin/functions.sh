#/bin/bash

# Provides functions used in start and stop scripts. Intended to be included
# in other scripts.

# Checks if Docker is installed on operating system
docker_installed() {
  if [[ ! -x $(command -v docker) ]]; then
    echo "Docker is required but not installed. Follow these instructions to install:"
    echo "https://docs.docker.com/docker-for-mac/"
    exit 1
  fi
}
